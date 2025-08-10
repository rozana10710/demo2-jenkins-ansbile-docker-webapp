## Docker

Simple static web app served by a lightweight web server.

### Contents
- `dockerfile`: Builds the `simple-web` image
- `index.html`: Demo page

### Build locally
```
cd docker
docker build -t simple-web:latest .
```

### Run locally
```
docker run -d --name simple-web -p 80:80 --restart unless-stopped simple-web:latest
```
Open http://localhost

### CI build context
- Jenkins/Ansible pipeline builds from: `<repo-root>/docker`
- Image is tagged and pushed as: `<DOCKERHUB_USERNAME>/simple-web:latest`