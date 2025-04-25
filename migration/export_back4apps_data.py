import requests
import json
from dotenv import load_dotenv
import os


load_dotenv()

# Get environment variables
APP_ID = os.getenv("BACK4APP_APP_ID")
REST_KEY = os.getenv("BACK4APP_REST_KEY")
SERVER_URL = os.getenv("BACK4APP_SERVER_URL")
BASE_URL = f"{SERVER_URL}/parse"
TABLES = os.getenv('TABLES').split(',')

headers = {
    "X-Parse-Application-Id": APP_ID,
    "X-Parse-REST-API-Key": REST_KEY
}

export_data = {}

for class_name in TABLES:
    print(f"Exporting data from class: {class_name}")
    
    url = f"{BASE_URL}/classes/{class_name}"
    
    # Limiting the number of records at a time
    params = {
        "limit": 1000  
    }

    response = requests.get(url, headers=headers, params=params)
    
    # Checking if the request was successful
    if response.status_code == 200:
        data = response.json()
        export_data[class_name] = data["results"]
    else:
        print(f"Error fetching data for class {class_name}: {response.status_code} - {response.text}")
    
# Save JSON file
with open("export.json", "w", encoding="utf-8") as f:
    json.dump(export_data, f, indent=2, ensure_ascii=False)

print("Export completed.")
