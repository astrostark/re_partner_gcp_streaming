import apache_beam as beam

from apache_beam.options.pipeline_options import PipelineOptions, GoogleCloudOptions, StandardOptions, SetupOptions, WorkerOptions
from apache_beam.transforms.window import FixedWindows
from apache_beam.io import fileio
from apache_beam import pvalue

from datetime import datetime
from json import loads, dumps

PROJECT_ID = "re-partner-4800006"
SUBSCRIPTION_ID = "backend-events-topic-sub"
FULL_SUBSCRIPTION_PATH = f"projects/{PROJECT_ID}/subscriptions/{SUBSCRIPTION_ID}"
REGION = "us-east4"

BUCKET_ROOT = "gs://re-partner" 
BUCKET_TEMP = f"{BUCKET_ROOT}/temp"
BUCKET_STAGING = f"{BUCKET_ROOT}/staging"

DATASET_ID = "ecommerce_events"
TABLE_ORDER = f"{PROJECT_ID}:{DATASET_ID}.orders"
TABLE_INVENTORY = f"{PROJECT_ID}:{DATASET_ID}.inventory"
TABLE_USER = f"{PROJECT_ID}:{DATASET_ID}.user_activity"

TAG_ORDER = 'order'
TAG_INVENTORY = 'inventory'
TAG_USER = 'user_activity'

JOB_NAME = f"ecommerce-pipeline-{datetime.now().strftime('%Y%m%d-%H%M%S')}"

def create_gcs_path(record):
    try:
        event_type = record.get('event_type')
        if event_type == 'order':
            timestamp_field = 'order_date'
        elif event_type == 'inventory':
            timestamp_field = 'timestamp'
        elif event_type == 'user_activity':
            timestamp_field = 'timestamp'
        else:
            print(f"Event Ignored (Unknow event type): {event_type}")
        date_value = datetime.fromisoformat(record[timestamp_field])
    except Exception:
        event_type = "errors"
        date_value = datetime.now()
    return f"output/{event_type}/{date_value.year}/{date_value.month:02d}/{date_value.day:02d}/{date_value.hour:02d}/{date_value.minute:02d}"

def naming_strategy(window, pane, shard_index, total_shards, compression, destination):
    try:
        parts = destination.split('/')
        if len(parts) > 1:
            prefix = parts[1]
        else:
            prefix = 'event'
        timestamp = datetime.now().strftime('%Y%m%d%H%M')
        return f"{destination}/{prefix}_{timestamp}_{shard_index:05d}.json"
    except:
        return f"{destination}/error_{shard_index:05d}.json"
    
class RouterAndClean(beam.DoFn):
    def process(self, element):
        try:
            record = loads(element.decode('utf-8'))
            event_type = record.get('event_type')

            if event_type == 'order':
                timestamp_field = 'order_date'
            elif event_type == 'inventory':
                timestamp_field = 'timestamp'
            elif event_type == 'user_activity':
                timestamp_field = 'timestamp'
            else:
                print(f"Event Ignored (Unknow event type): {event_type}")
            
            if event_type:
                record[timestamp_field] = record[timestamp_field].split('+')[0]
                yield pvalue.TaggedOutput(event_type, record)

        except Exception as e:
            print(f"Crital error: {e}")

def run():
    options = PipelineOptions()
    standard_options = options.view_as(StandardOptions)
    standard_options.runner = 'DataflowRunner'
    standard_options.streaming = True
    google_cloud_options = options.view_as(GoogleCloudOptions)
    google_cloud_options.project = PROJECT_ID
    google_cloud_options.region = REGION
    google_cloud_options.job_name = JOB_NAME
    google_cloud_options.staging_location = BUCKET_STAGING
    google_cloud_options.temp_location = BUCKET_TEMP
    setup_options = options.view_as(SetupOptions)
    setup_options.save_main_session = True
    setup_options.requirements_file = 'requirements.txt'
    worker_options = options.view_as(WorkerOptions)
    worker_options.machine_type = 'e2-small'
    worker_options.num_workers = 1
    worker_options.max_num_workers = 1
    with beam.Pipeline(options=options) as p:
        resultados = (
            p
            | "Reading from PubSub" >> beam.io.ReadFromPubSub(subscription=FULL_SUBSCRIPTION_PATH)
            | "Router and Clean" >> beam.ParDo(RouterAndClean()).with_outputs(
                TAG_ORDER, 
                TAG_INVENTORY, 
                TAG_USER, 
                main='ignored'
            )
        )

        (
            resultados[TAG_ORDER] 
            | "Write Orders" >> beam.io.WriteToBigQuery(
                table=TABLE_ORDER,
                create_disposition=beam.io.BigQueryDisposition.CREATE_NEVER,
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
            )
        )
        
        (
            resultados[TAG_INVENTORY] 
            | "Write Inventory" >> beam.io.WriteToBigQuery(
                table=TABLE_INVENTORY,
                create_disposition=beam.io.BigQueryDisposition.CREATE_NEVER,
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
            )
        )

        (
            resultados[TAG_USER] 
            | "Write UserActivity" >> beam.io.WriteToBigQuery(
                table=TABLE_USER,
                create_disposition=beam.io.BigQueryDisposition.CREATE_NEVER,
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
            )
        )

        todos_eventos = (
            (
                resultados[TAG_ORDER], 
                resultados[TAG_INVENTORY], 
                resultados[TAG_USER]
            ) | "Flatting results" >> beam.Flatten()
        )

        (
            todos_eventos
            | "1 minute Windows" >> beam.WindowInto(FixedWindows(60))
            | "JSON String" >> beam.Map(lambda x: dumps(x))
            | "Writing on GCS" >> fileio.WriteToFiles(
                path=BUCKET_ROOT,
                destination=lambda r: create_gcs_path(loads(r)),
                sink=fileio.TextSink(),
                file_naming=naming_strategy
            )
        )

if __name__ == '__main__':
    print("---------------------------------------------------------")
    print(f">>> Starting Pipeline                                   ")
    print("---------------------------------------------------------")
    
    try:
        run()
    except KeyboardInterrupt:
        print("\Stopping pipeline...")