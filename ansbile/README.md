## Ansible playbook: build, push, and run the simple web app

### What it does
- Builds a Docker image from `docker/dockerfile` in the checked-out repo
- Tags it as `<DOCKERHUB_USERNAME>/simple-web:latest`
- Pushes to Docker Hub
- Runs the container as a persistent service (`--restart unless-stopped`), mapping `80:80`

### Assumptions
- Jenkins agent label: `slave` (adjust as needed)
- Repo is checked out by Jenkins to: `/home/jenkins/workspace/simple-web-app`
- Dockerfile path used by the playbook: `/home/jenkins/workspace/simple-web-app/docker/dockerfile`
- User running the pipeline is `jenkins` and is in the `docker` group

### Required tools on the agent
- Docker (CLI + daemon running)
- Ansible

### Required credentials (Jenkins parameters)
- `DOCKERHUB_USERNAME` (string)
- `DOCKERHUB_PASSWORD` (password)

These are passed to the playbook as environment variables and used for `docker login`.

### How the playbook runs
- File: `ansbile/main_playbook.yaml`
- Runs on `localhost` without sudo (`become: false`), `gather_facts: false`
- Uses environment variables `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD`
- Build context: `/home/jenkins/workspace/simple-web-app/docker`
- Image/tag defaults: `simple-web:latest`

### Jenkins pipeline snippet
```groovy
pipeline {
  agent { label 'slave' }
  parameters {
    string(name: 'DOCKERHUB_USERNAME', defaultValue: '', description: 'Docker Hub username')
    password(name: 'DOCKERHUB_PASSWORD', defaultValue: '', description: 'Docker Hub password or token')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', credentialsId: 'github', url: 'https://github.com/rozana10710/demo2-jenkins-ansbile-docker-webapp.git'
      }
    }
    stage('Build & Push') {
      steps {
        sh 'ansible-playbook ansbile/main_playbook.yaml'
      }
    }
  }
}
```

### Run manually on the agent (optional)
```bash
export DOCKERHUB_USERNAME=yourhubuser
export DOCKERHUB_PASSWORD=yourtoken
ansible-playbook ansbile/main_playbook.yaml
```

### Customization (edit `ansbile/main_playbook.yaml` vars)
- `docker_image_name` (default: `simple-web`)
- `docker_tag` (default: `latest`)
- `docker_context_dir` (default: `/home/jenkins/workspace/simple-web-app/docker`)
- `dockerfile_name` (default: `dockerfile`)
- `host_port`/`container_port` (default: `80:80`)

### Troubleshooting
- Permission denied to Docker:
  - Ensure the `jenkins` user is in the `docker` group; re-login or restart the agent
  - `id jenkins` should list `docker`
- Push fails:
  - Verify `DOCKERHUB_USERNAME`/`DOCKERHUB_PASSWORD`
  - `docker login` should succeed on the agent
- Wrong build context:
  - Confirm Jenkins workspace path and Dockerfile location match the defaults or update `docker_context_dir`/`dockerfile_name`