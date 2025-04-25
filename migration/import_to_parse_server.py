import os
import json
import requests
from dotenv import load_dotenv

load_dotenv()

PARSE_URL = os.getenv("PARSE_SERVER_URL")
APP_ID = os.getenv("PARSE_APP_ID")
CLIENT_KEY = os.getenv("PARSE_CLIENT_KEY")
EXPORT_FILE = os.getenv("PARSE_EXPORT_FILE", "./export.json")

HEADERS = {
    "X-Parse-Application-Id": APP_ID,
    "X-Parse-Client-Key": CLIENT_KEY,
    "Content-Type": "application/json"
}

def import_data_from_file(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        data = json.load(f)

    for class_name, objects in data.items():
        print(f"\n📦 Importing class: {class_name} ({len(objects)} records)")
        for obj in objects:
            obj.pop("objectId", None)
            obj.pop("createdAt", None)
            obj.pop("updatedAt", None)

            res = requests.post(f"{PARSE_URL}/classes/{class_name}", headers=HEADERS, json=obj)
            if res.status_code == 201:
                print("✅ Inserted")
            else:
                print(f"❌ Failed: {res.text}")

import_data_from_file(EXPORT_FILE)
