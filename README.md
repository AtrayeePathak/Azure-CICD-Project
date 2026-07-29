 # Example Voting App - Azure GitOps Deployment

A simple distributed microservices application running across multiple Docker containers, deployed to Microsoft Azure using a fully automated GitOps CI/CD pipeline.

## Application Architecture

* A front-end web app in [Python](/vote) which lets you vote between two options
* A [Redis](https://hub.docker.com/_/redis/) queue which collects new votes
* A [.NET](/worker/) worker which consumes votes and stores them in…
* A [Postgres](https://hub.docker.com/_/postgres/) database backed by a Docker volume
* A [Node.js](/result) web app which shows the results of the voting in real time

## Architecture Diagram

![Architecture Diagram](azure%20project.png)

## Cloud Infrastructure & CI/CD Architecture

This project implements a zero-touch deployment workflow using the following Azure and GitOps technologies:

* **Continuous Integration:** Azure DevOps pipeline running on a self-hosted Linux agent (Azure Virtual Machine).
* **Container Registry:** Azure Container Registry (ACR) hosts the built Docker container images.
* **Continuous Deployment:** Argo CD deployed directly inside the Kubernetes cluster.
* **Kubernetes Orchestration:** Azure Kubernetes Service (AKS) hosts the running application.
* **Traffic Routing:** Azure Load Balancer exposes the Vote and Result microservices to external users.

### How the Pipeline Works

1. **Code Commit:** Code changes pushed to this GitHub repository trigger the Azure DevOps CI pipeline via webhooks.
2. **Build & Push:** The self-hosted Linux agent builds new Docker images for the modified microservices and pushes them to the Azure Container Registry.
3. **Automated Manifest Update:** A custom shell script runs in the pipeline to dynamically update the image tags in the Kubernetes deployment YAML files. The script automatically commits and pushes these changes back to this repository.
4. **GitOps Sync:** Argo CD continuously monitors the repository. Upon detecting the automated manifest updates, it synchronizes the AKS cluster state by applying the new configurations via a rolling update.

## Repository Specifications

* `/vote`, `/result`, `/worker`: Source code and Dockerfiles for the individual application microservices.
* `/k8s-specifications`: Contains the core Kubernetes YAML manifests (Deployments and Services). **Argo CD is configured to watch this specific directory** as the single source of truth for the desired cluster state. 
* `/Scripts`: Contains the automation shell scripts used by the Azure DevOps pipeline to update manifest files.

## Running Locally for Development

If you want to test the application locally before triggering the cloud CI/CD pipeline, you can use Docker Compose. Download [Docker Desktop](https://www.docker.com/products/docker-desktop) for your operating system.

Run the following command in the root directory to build and run the app:

```shell
docker compose up