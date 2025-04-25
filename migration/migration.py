import os
import requests
from pymongo import MongoClient
from dotenv import load_dotenv

load_dotenv()

APP_ID = os.getenv("BACK4APP_APP_ID")
REST_API_KEY = os.getenv("BACK4APP_REST_API_KEY")
MONGO_URI = os.getenv("MONGO_URI")
DATABASE_NAME = os.getenv("DATABASE_NAME")
CLASSES = os.getenv("CLASSES").split(",")

HEADERS = {
    "X-Parse-Application-Id": APP_ID,
    "X-Parse-REST-API-Key": REST_API_KEY,
}

def exportar_classe(nome_classe):
    url = f"https://parseapi.back4app.com/classes/{nome_classe.strip()}"
    resp = requests.get(url, headers=HEADERS)
    resp.raise_for_status()
    return resp.json().get("results", [])

def importar_para_mongo(nome_classe, dados):
    client = MongoClient(MONGO_URI)
    db = client[DATABASE_NAME]
    collection = db[nome_classe.strip().lower()]
    collection.delete_many({})
    if dados:
        collection.insert_many(dados)
    print(f"Classe {nome_classe} migrada com sucesso.")
    client.close()

def main():
    for classe in CLASSES:
        dados = exportar_classe(classe)
        importar_para_mongo(classe, dados)

if __name__ == "__main__":
    main()
