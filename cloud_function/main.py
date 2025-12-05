from random import choice, randint, uniform
from functions_framework import http
from fake_useragent import UserAgent
from google.cloud import pubsub_v1
from datetime import datetime, UTC
from faker import Faker
from uuid import uuid4
from json import dumps
from os import environ

fake = Faker()
ua = UserAgent()
publisher = pubsub_v1.PublisherClient()

PROJECT_ID = environ.get('GCP_PROJECT', 're-partner-4800006')
TOPIC_ID = "backend-events-topic"
TOPIC_PATH = publisher.topic_path(PROJECT_ID, TOPIC_ID)

def create_order_event():
    items = []
    for _ in range(randint(1, 4)):
        price = round(uniform(10, 200), 2)
        qty = randint(1, 3)
        total = price * qty
        items.append({
            "product_id": str(uuid4()),
            "product_name": fake.word(),
            "quantity": qty,
            "price": price
        })
    return {
        "event_type": "order",
        "order_id": str(uuid4()),
        "customer_id": str(uuid4()),
        "order_date": datetime.now(UTC).isoformat(),
        "status": choice(["pending", "processing", "shipped", "delivered"]),
        "items": items,
        "shipping_address": {"street": fake.address(), "city": fake.city(), "country": fake.country()},
        "total_amount": round(total, 2)
    }

def create_inventory_event():
    return {
        "event_type": "inventory",
        "inventory_id": str(uuid4()),
        "product_id": str(uuid4()),
        "warehouse_id": str(uuid4()),
        "quantity_change": randint(-100, 100),
        "reason": choice(["restock", "sale", "return", "damage"]),
        "timestamp": datetime.now(UTC).isoformat()
    }

def create_user_activity_event():
    return {
        "event_type": "user_activity",
        "user_id": str(uuid4()),
        "activity_type": choice(["login", "logout", "view_product", "add_to_cart", "remove_from_cart"]),
        "ip_address": fake.ipv4(),
        "user_agent": ua.random,
        "timestamp": datetime.now(UTC).isoformat(),
        "metadata": {
            "session_id": str(uuid4()), 
            "platform": choice(["web", "mobile", "tablet"])
        }
    }

def generate_data():
    event_type = choice(["order", "user_activity", "inventory"])
    if event_type == 'order':
        return create_order_event()
    elif event_type == 'inventory':
        return create_inventory_event()
    else:
        return create_user_activity_event()

@http
def publish_trigger(request):
    try:
        request_json = request.get_json(silent=True)
        request_args = request.args
        count = 1
        if request_args and 'count' in request_args:
            count = int(request_args['count'])
        elif request_json and 'count' in request_json:
            count = int(request_json['count'])

        for _ in range(count):
            future = publisher.publish(TOPIC_PATH, dumps(generate_data()).encode("utf-8"))

        return f"{count} events created on {TOPIC_ID}.", 200

    except Exception as e:
        return f"Erro: {str(e)}", 500