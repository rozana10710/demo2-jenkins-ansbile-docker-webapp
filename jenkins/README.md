## Jenkins

Declarative pipeline in `jenkins/Jenkinsfile`.

### Agent
- Runs on node with label `slave`
- Requires Docker and Ansible installed
- The `jenkins` user must be in the `docker` group

### Stages
- Checkout (HTTPS Git with credentials `github`)
- Build & Push with Ansible: runs `ansbile/main_playbook.yaml`

### Parameters (set in Jenkins job)
- `DOCKERHUB_USERNAME` (string)
- `DOCKERHUB_PASSWORD` (password)

These are passed to Ansible as environment variables.

### Outputs
- Docker image pushed to `docker.io/<DOCKERHUB_USERNAME>/simple-web:latest`
- Container started on the agent, mapped to port 80

### Tips
- If switching to SSH checkout, configure host key and SSH credentials
- To view container logs on the agent: `docker logs -f simple-web`