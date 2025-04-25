import subprocess
import argparse
import os
from dotenv import load_dotenv

load_dotenv(dotenv_path="./configs/.env")

TERRAFORM_DIR = "./infra/"
MIGRATION_DIR = "./migration/"
APP_DIR = "./app/"

def create_terraform_config():
    with open("configs/terraform.config.template.tfvars") as template:
        content = template.read()
        content = content.replace("{MONGODB_ATLAS_API_PUB_KEY}", os.getenv("MONGODB_ATLAS_API_PUB_KEY"))
        content = content.replace("{MONGODB_ATLAS_API_PRI_KEY}", os.getenv("MONGODB_ATLAS_API_PRI_KEY"))
        content = content.replace("{MONGODB_ATLAS_ORG_ID}", os.getenv("MONGODB_ATLAS_ORG_ID"))
        content = content.replace("{MONGODB_ATLAS_DATABASE_USERNAME}", os.getenv("MONGODB_ATLAS_DATABASE_USERNAME"))
        content = content.replace("{MONGODB_ATLAS_DATABASE_PASSWORD}", os.getenv("MONGODB_ATLAS_DATABASE_PASSWORD"))
        content = content.replace("{GCP_PROJECT_ID}", os.getenv("GCP_PROJECT_ID"))
        content = content.replace("{GCP_REGION_ID}", os.getenv("GCP_REGION_ID"))
        content = content.replace("{PARSE_MASTER_KEY}", os.getenv("PARSE_MASTER_KEY"))
        content = content.replace("{PARSE_APP_ID}", os.getenv("PARSE_APP_ID"))
        content = content.replace("{PARSE_CLIENT_KEY}", os.getenv("PARSE_CLIENT_KEY"))
    with open("infra/secrets.tfvars", "w") as terraform_secrets:
        terraform_secrets.write(content)
    print("⚙️ Terraform configuration files created.")

def create_migration_config():
    with open("configs/migration.config.template.env") as template:
        content = template.read()
        content = content.replace("{BACK4APP_APP_ID}", os.getenv("BACK4APP_APP_ID"))
        content = content.replace("{BACK4APP_REST_KEY}", os.getenv("BACK4APP_REST_KEY"))
        content = content.replace("{BACK4APP_SERVER_URL}", os.getenv("BACK4APP_SERVER_URL"))
        content = content.replace("{TABLES}", os.getenv("TABLES"))
        content = content.replace("{PARSE_SERVER_URL}", os.getenv("PARSE_SERVER_URL"))
        content = content.replace("{PARSE_APP_ID}", os.getenv("PARSE_APP_ID"))
        content = content.replace("{PARSE_CLIENT_KEY}", os.getenv("PARSE_CLIENT_KEY"))
    with open("migration/.env", "w") as migration_config:
        migration_config.write(content)
    print("📦 Migration configuration files created.")

def create_app_config(option="back4app"):
    with open("configs/app.config.template.env") as template:      
        content = template.read()
        if(option == "gcp"):
            print("Creating app config for GCP backend")
            content = content.replace("{PARSE_APP_ID}", os.getenv("PARSE_APP_ID"))
            content = content.replace("{PARSE_SERVER_URL}", os.getenv("PARSE_SERVER_URL"))
            content = content.replace("{PARSE_CLIENT_KEY}", os.getenv("PARSE_CLIENT_KEY"))
        else:
            print("Creating app config for Back4App backend")
            content = content.replace("{PARSE_APP_ID}", os.getenv("BACK4APP_APP_ID"))
            content = content.replace("{PARSE_SERVER_URL}", os.getenv("BACK4APP_SERVER_URL"))
            content = content.replace("{PARSE_CLIENT_KEY}", os.getenv("BACK4APP_CLIENT_KEY"))
    with open("app/.env", "w") as app_config:
        app_config.write(content)
    print("📱 App configuration files created.")

def deploy_infra():
    print("🚀 Starting infrastructure deployment...")
    os.chdir(TERRAFORM_DIR)
    subprocess.run(["terraform", "init"], check=True)
    subprocess.run(["terraform", "apply", "-auto-approve", "-var-file", "./secrets.tfvars"], check=True)

def destroy_infra():
    print("🧨 Destroying infrastructure...")
    os.chdir(TERRAFORM_DIR)
    subprocess.run(["terraform", "init"], check=True)
    subprocess.run(["terraform", "destroy", "-auto-approve", "-var-file", "./secrets.tfvars"], check=True)

def migrate_backend():
    print("🔄 Starting backend migration...")
    os.chdir(MIGRATION_DIR)
    subprocess.run(["docker-compose", "up"], check=True)

def build_apk(option):
    print("📱 Building Flutter APK...")
    create_app_config(option)
    os.chdir(APP_DIR)
    subprocess.run(["flutter", "clean"], check=True, shell=True)
    subprocess.run(["flutter", "pub", "get"], check=True, shell=True)
    subprocess.run(["flutter", "build", "apk", "--release"], check=True, shell=True)

def cleanup():
    print("🧹 Cleaning up temporary files...")
    filesToRemove = [TERRAFORM_DIR + "secrets.tfvars", MIGRATION_DIR + ".env", APP_DIR + ".env"]
    for file in filesToRemove:
        if(os.path.exists(file)):
            os.remove(file)
            print(file, "removed.")

def main():
    parser = argparse.ArgumentParser(description="✨ Automate your workflow with a touch of magic!")
    parser.add_argument('--deploy-infra', action='store_true', help="Deploy infrastructure using Terraform")
    parser.add_argument('--destroy-infra', action='store_true', help="Destroy the deployed infrastructure")
    parser.add_argument('--migrate-backend', action='store_true', help="Run backend migration from Back4App to GCP using Docker")
    parser.add_argument('--create-configs', action='store_true', help="Generate required configuration files")
    parser.add_argument('--cleanup', action='store_true', help="Remove temporary or generated files")
    parser.add_argument('--build-apk', choices=['back4app', 'gcp'], nargs='?', help="Builds an Android APK for Back4App (default) or GCP.")
    
    args = parser.parse_args()

    if args.deploy_infra:
        deploy_infra()
    
    if args.destroy_infra:
        destroy_infra()

    if args.migrate_backend:
        migrate_backend()

    if args.create_configs:
        create_terraform_config()
        create_migration_config()
        create_app_config()

    if args.cleanup:
        cleanup()

    if args.build_apk:
        build_apk(args.build_apk)

if __name__ == "__main__":
    main()
