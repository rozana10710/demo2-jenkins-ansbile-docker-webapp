## Jenkins
<img width="2940" height="1658" alt="image" src="https://github.com/user-attachments/assets/41c92697-e0f7-4f58-a334-75f240043c90" />


Declarative pipeline in `jenkins/Jenkinsfile`.

### Agent
- Runs on node with label `slave`
- Requires Docker and Ansible installed
- The `jenkins` user must be in the `docker` group

### Stages
- Checkout (HTTPS Git with credentials `github`)
- Build & Push with Ansible: runs `ansbile/main_playbook.yaml`

### Parameters (set in Jenkins job)
<img width="2688" height="768" alt="image" src="https://github.com/user-attachments/assets/36ccd4be-c518-4af2-889c-2967ba4d9efe" />

- `DOCKERHUB_USERNAME` (string)
- `DOCKERHUB_PASSWORD` (password)

These are passed to Ansible as environment variables.

### Outputs
- Docker image pushed to `docker.io/<DOCKERHUB_USERNAME>/simple-web:latest`
- Container started on the agent, mapped to port 80

### Tips
- If switching to SSH checkout, configure host key and SSH credentials
- To view container logs on the agent: `docker logs -f simple-web`
