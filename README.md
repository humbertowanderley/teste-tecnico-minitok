## Introduction

This repository contains the solution to a technical challenge proposed by **Minitok**, a company focused on innovative tech solutions. The task was to build and deploy a fully functional backend migration from **Back4App** to **Google Cloud Platform (GCP)**, while integrating it with **MongoDB Atlas**. Additionally, the solution involved creating a **Flutter mobile app** that would seamlessly interact with both backends — **Back4App** and **GCP**.

The project was designed to explore new technologies and deepen my knowledge in areas that I had previously worked little with, including **GCP** and **Flutter**. The result is a robust and scalable architecture that can serve as a foundation for future applications, with a focus on cloud infrastructure, mobile app development, and secure backend management.

This technical challenge allowed me to dive into the world of cloud services, containerization, and app deployment, offering hands-on experience with tools like **Terraform**, **Docker**, and **Flutter**, while also learning about best practices for cloud architecture and backend migration. 🚀

---

## Project Architecture Diagram

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1JwiRzRYI2OMcUf3fXQTUIj8GiBaUDfca" alt="Diagram" />
</p>

---

## 📦 Project Structure

The project is organized into several directories and files, each serving a specific purpose. Below is an overview of the main components:

### `/app/`
This directory contains the **Flutter application** files. It includes:
- The source code for the mobile app's frontend.
- Environment configuration for the app to work with either the Back4App or GCP backend.

### `/configs/`
The **configuration files** for the project are stored here. It includes:
- Template files for environment variables (`.env`) that need to be customized with your project’s specific credentials.
- Terraform configuration templates for provisioning cloud infrastructure, such as `terraform.config.template.tfvars`.
- **.env Template**: This file includes placeholders for the required secrets (e.g., Back4App credentials, GCP credentials, MongoDB Atlas credentials). Refer to the documentation for guidance on how to fill these out.

### `/infra/`
This directory holds the **Terraform files** used for provisioning and managing cloud infrastructure, primarily on GCP. Key components include:
- Terraform scripts for creating and destroying cloud resources.
  
### `/migration/`
The migration-related files are stored in this directory. It contains:
- Scripts for migrating data from **Back4App** to **MongoDB Atlas**.
- A Docker configuration for running the migration process.

### `minimagic.py`
This is the core Python script for automating tasks such as:
- Creating the necessary configuration files.
- Deploying infrastructure using Terraform.
- Migrating data from Back4App to MongoDB Atlas.
- Building Android APKs for both Back4App and GCP backends.

---

This structure ensures a clean separation of concerns, making it easy to manage and scale the project. Each directory and file serves a specific role, and understanding their purpose is crucial for working with the project efficiently.

---

## 🚀 Stack Used

- **Flutter** (mobile application + APK build automation)
- **Parse Server** (containirized inside a docker container on GCP VM)
- **MongoDB Atlas** (Integrated with GCP)
- **Back4App** (original backend app source)
- **Terraform** (infrastructure provisioning)
- **Docker + Docker Compose** (data migration automation)
- **Python + argparse** (workflow orchestration, and utils scripts)

---

### 🧰 Requirements

Before running this project, make sure you have the following:

- ✅ [**Python 3**](https://www.python.org/downloads/) installed
- ✅ [**Docker**](https://docs.docker.com/get-docker/) & [**Docker Compose**](https://docs.docker.com/compose/install/) installed
- ✅ [**Google Cloud SDK (gcloud CLI)**](https://cloud.google.com/sdk/docs/install) installed and configured
- ✅ [**Terraform**](https://developer.hashicorp.com/terraform/downloads) installed
- ✅ [**Flutter SDK**](https://docs.flutter.dev/get-started/install) installed and added to your PATH
- ✅ [**Visual Studio Code**](https://code.visualstudio.com/) installed (or any IDE of your choice)
- ✅ [**Android SDK**](https://developer.android.com/studio) installed and configured (required for building APKs)
- ✅ A **Terraform service account** created in GCP ([guide](https://cloud.google.com/iam/docs/creating-managing-service-accounts))
- ✅ A **GCP credentials JSON** file generated for Terraform ([how to create](https://developers.google.com/workspace/guides/create-credentials))
- ✅ A **[Google Cloud Platform (GCP)](https://cloud.google.com/free)** account on the Free Tier
- ✅ A **[MongoDB Atlas](https://www.mongodb.com/atlas/database)** account with a Free Tier cluster
- ✅ A project created on MongoDB Atlas, [linked to GCP](https://www.mongodb.com/docs/atlas/cloud-provider-snapshots/google-cloud-snapshots/)
- ✅ A configured **[Back4App](https://www.back4app.com/)** backend (source of data)
- ✅ A valid Parse schema and data on Back4App

---

### 🧭 Quick Setup Summary

1. 🔐 Create a [**GCP service account**](https://cloud.google.com/iam/docs/creating-managing-service-accounts) with `roles/editor` and `roles/iam.serviceAccountUser`
2. 🗂️ [Download and save the credentials JSON file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
3. 🌐 [Create a project and cluster in MongoDB Atlas](https://www.mongodb.com/docs/atlas/getting-started/)
4. 🔗 [Connect your MongoDB Atlas project to GCP](https://www.mongodb.com/docs/atlas/cloud-provider-snapshots/google-cloud-snapshots/)
6. 📥 Clone this repository and fill in the `.env_template` under `/configs` with MongoDB Atlas, Google Cloud Provider and Back4Apps secret keys, so rename to  `.env`. 

---

### 🔐 Environment Variables Setup

Create a `.env` file based on the template provided in `configs/`. Below is a guide on how to retrieve each value:

#### 🔵 Back4App Secrets

| **Variable**              | **Description**                                                                          | **Where to Find**                                                              |
|---------------------------|------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| `BACK4APP_APP_ID`          | Your app's unique ID                                                                     | [Back4App App Settings → App ID](https://dashboard.back4app.com/)             |
| `BACK4APP_REST_KEY`        | REST API Key used to access your Back4App app                                           | [Back4App App Settings → Security & Keys](https://dashboard.back4app.com/)    |
| `BACK4APP_CLIENT_KEY`      | Optional, used for client-side requests (not mandatory for migration)                    | Same as above                                                                  |
| `BACK4APP_SERVER_URL`      | Default: `https://parseapi.back4app.com`                                                 | Always the same unless custom domain                                          |
| `TABLES`                   | Comma-separated list of tables to migrate (e.g., `User,Posts,Comments`)                  | You define this manually                                                       |

#### ☁️ GCP & Parse Server Secrets

| **Variable**               | **Description**                                                                          | **Where to Find**                                                              |
|----------------------------|------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| `PARSE_SERVER_URL`          | Public IP of your deployed Parse Server VM (via Terraform)                               | Check Terraform output or VM IP on [Google Cloud Console](https://console.cloud.google.com/) |
| `PARSE_APP_ID`              | ID you set in `main.js` of the Parse Server during deployment                            | Your own defined constant                                                     |
| `PARSE_CLIENT_KEY`          | Client key set in `main.js` of the Parse Server                                          | Your own defined constant                                                     |
| `PARSE_MASTER_KEY`          | Master key set in `main.js` of the Parse Server                                          | Your own defined constant                                                     |
| `GCP_PROJECT_ID`            | Your GCP project ID                                                                      | From [GCP Dashboard](https://console.cloud.google.com/cloud-resource-manager) |
| `GCP_REGION_ID`             | Region where your VM and resources are deployed (e.g., `us-central1`)                    | Same as specified in Terraform configs                                        |

#### 🟢 MongoDB Atlas Secrets

| **Variable**                           | **Description**                                                                           | **Where to Find**                                                              |
|----------------------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
| `MONGODB_ATLAS_API_PUB_KEY`            | Public API key to manage your Atlas project                                                | [MongoDB Atlas → Organization Access Manager → API Keys](https://www.mongodb.com/docs/atlas/api/atlas-admin-api/) |
| `MONGODB_ATLAS_API_PRI_KEY`            | Private key from the same API key pair                                                    | Same as above                                                                  |
| `MONGODB_ATLAS_ORG_ID`                 | Organization ID where your Atlas project exists                                          | In the Atlas URL or under Organization settings                               |
| `MONGODB_ATLAS_DATABASE_USERNAME`      | Database user with read/write access                                                     | [Atlas → Database → Database Access](https://www.mongodb.com/docs/atlas/security/database-users/) |
| `MONGODB_ATLAS_DATABASE_PASSWORD`      | Password for the above database user                                                     | Same as above                                                                  |

> 📁 After filling your `.env`, **do not** commit it to the repository. You can use `.gitignore` to keep it private.





### 🛠️ How It Works

Here’s a step-by-step guide to get everything up and running:

---

### 1. 🌱 **Set up the `.env` file**

Before anything else, you need to configure your environment variables.

- Copy the `.env` template from the `configs/` folder.
- Fill in all the necessary values for each environment variable.
  - Each variable is explained in the template, and you'll need to get these values from your GCP, MongoDB Atlas, Back4App, and other accounts.

Make sure to replace the placeholders in the `.env` file with your actual credentials and information.

### 2. ⚙️ **Create Configuration Files**

Once the `.env` file is filled, generate the required configuration files for both the infrastructure and migration setup.

Run the following command to generate the necessary configuration files:

```bash
python ./minimagic.py --create-configs
```
This command will:

- Create the Terraform configuration files (terraform secrets.tfvar).

- Create the migration configuration files ( docker container .env).

- Generate the app configuration file (app .env).

These files are essential for deploying your infrastructure and migrating data from Back4App to MongoDB.

### 3. 🌐 **Deploy the Infrastructure**

Now it’s time to deploy your infrastructure using Terraform. This will set up everything on your GCP account, including resources like VMs and network configurations.

Run the following command to deploy the infrastructure:

```bash
python ./minimagic.py --deploy-infra
```
This command will:

Initialize Terraform.

Apply the Terraform configurations and deploy the necessary resources on your GCP account.

After running this, your infrastructure will be up and ready to handle the backend operations.

### 4. 🔄 **Migrate Data from Back4App to MongoDB Atlas**

Next, you’ll migrate your data from Back4App to MongoDB Atlas. This step involves transferring your existing data to the new GCP-backed infrastructure.

Before you start, make sure the **public IP** of your GCP VM is added to the whitelist of MongoDB Atlas to allow the connection.

Once that’s set up, execute the migration with the following command:

```bash
python ./minimagic.py --migrate-backend
```
This command will:

Start the Docker container to run the migration.

Transfer data from Back4App to your MongoDB Atlas cluster through the Parse Server running on your GCP VM.

### 5. 📱 **Build APK for Back4App Backend**

Now, you’ll build the APK for your Flutter app, configured to connect to the Back4App backend. This step will create an Android app that communicates with your existing Back4App setup.

Run the following command to build the APK:

```bash
python ./minimagic.py --build-apk back4app
```
This command will:

Generate the Flutter app’s APK file.

Set the app to point to the Back4App backend.

Once built, you’ll have an APK ready to be installed on your Android device.

### 6. 📱 **Build APK for GCP Backend**

After testing the app with the Back4App backend, you can now build an APK that connects to the new GCP-based backend.

To build this APK, run the following command:

```bash
python ./minimagic.py --build-apk gcp
```

### 7. 📲 **Install the APK on an Android Device**

Now that you have the APKs for both the Back4App and GCP configurations, it’s time to install them on your Android device.

- Transfer the APK files to your Android device.
- Install each APK (you may need to enable "Install from Unknown Sources" in your Android settings).
- Test each APK individually by launching the app and ensuring it connects to the correct backend (Back4App or GCP).

Make sure that both APKs are installed properly on your device and that the apps are functioning as expected.

### 8. ✅ **Verify App Functionality**

Finally, test both APKs on your Android device to ensure they are working properly and connecting to their respective backends.

- Open the APK that connects to **Back4App** and verify that it interacts with the Back4App backend as expected.
- Open the APK that connects to the **GCP backend** and verify that it communicates correctly with the Parse Server running on your GCP VM.

Both apps should be functioning equally, allowing you to seamlessly switch between the two environments and ensuring that the migration process has been successful.


## APKs for Testing

The APKs for both the Back4App and GCP backend configurations have been built and are available for testing.

- [Download APK for Back4App Backend](https://drive.google.com/file/d/1YUT1HH2VDJMRm4d0XAbslQTxyK_Lqz8k/view?usp=sharing)
- [Download APK for GCP Backend](https://drive.google.com/file/d/10fr_Kadwvsj-RrilDnnEwAp87WkhTCfI/view?usp=sharing)

### Infrastructure Availability

The infrastructure for both backends (Back4App and GCP) is fully configured and deployed for testing purposes. Both setups are live and operational, and I will keep them running for a period of time to allow for team evaluation.

Feel free to test the APKs with their respective backends and provide feedback based on your experience.

The GCP-based backend is running on a **Parse Server** deployed in a virtual machine (VM), and the **Back4App** backend is ready to handle the requests from the corresponding APK.

---

### Key Challenges
The project presented several challenges that required problem-solving and adaptation:

- **GCP Setup and Configuration**: As someone with limited experience with GCP, setting up the infrastructure, configuring IAM roles, and managing the authentication of Terraform with GCP was a challenging task. However, it provided an invaluable opportunity to learn about Google Cloud's ecosystem, especially related to cloud compute, networking, deployment.
- **Flutter App Configuration**: Working with Flutter to create a seamless app experience for two different backends (Back4App and GCP) posed a challenge. Ensuring that the app could switch between backends depending on the configuration was crucial, but at times tricky to implement due to different endpoint configurations and requirements.
- **Environment Configuration and Secrets Management**: A challenge during the project was managing the environment variables and secrets securely. Storing API keys and credentials in `.env` files and ensuring they were securely handled throughout the project required careful consideration and attention to best practices.

### Personal Growth
Overall, this project was a great learning experience. It allowed me to:

- **Gain hands-on experience with GCP**: I had minimal experience with GCP prior to this project. However, I was able to dive into Google Cloud’s offerings, including Compute Engine, IAM roles, and the setup of MongoDB Atlas within GCP.
- **Deepen my knowledge of Flutter**: While I had some familiarity with Flutter, this project pushed me to learn more deeply about Flutter’s build system, the intricacies of integrating different backends, and best practices for mobile app deployment.
- **Improve problem-solving skills**: Each challenge I encountered forced me to adapt, learn new technologies, and think critically to overcome obstacles, which significantly improved my technical skills.

This experience was incredibly rewarding and allowed me to enhance both my cloud and mobile development skill sets. The integration of GCP with Flutter and MongoDB Atlas is something I feel much more confident with, and I look forward to applying these skills to future projects.
