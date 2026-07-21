# cicd-demo-app

A local CI/CD pipeline demo: **Git → Jenkins → Docker build → Terraform apply → running container.**

A small Flask app is built into a Docker image by Jenkins and deployed as a container by Terraform, entirely on a local machine (no cloud, no registry).

## Repository layout

```
repo-root/
├── app/
│   ├── app.py            # Flask app (2 routes: / and /health)
│   └── requirements.txt  # flask==3.0.3
├── terraform/
│   └── main.tf           # Docker provider; deploys the locally built image
├── Dockerfile            # python:3.11-slim, runs app.py on port 5000
├── Jenkinsfile           # Pipeline: build image → terraform apply → verify
├── .gitignore
└── README.md
```

> `terraform/main.tf` and `Jenkinsfile` are added during integration.

## Conventions

| Thing | Value |
|---|---|
| Image name | `cicd-demo-app` |
| Container name | `cicd-demo-app` |
| App port (inside container) | `5000` |
| App port (on host) | `8081` |
| Jenkins port | `8080` |
| Terraform directory | `terraform/` |

## The app

- `GET /` → `{"message": "Deployed by Jenkins + Terraform", "build": "<BUILD_NUMBER>"}`
- `GET /health` → `{"status": "ok"}`

Flask binds to `0.0.0.0:5000` so it is reachable from outside the container. On the host the app is published on port **8081**.

## How the pipeline runs

Jenkins runs in a container built from a custom image (`jenkins/jenkins:lts` + Docker CLI + Terraform), with the host Docker socket bind-mounted in. On each poll of `main`, Jenkins builds the image, then Terraform deploys/updates the `cicd-demo-app` container. Once deployed, the app is available at `http://localhost:8081`.

## Team

Final project — Hatem, Luis, Joey.
