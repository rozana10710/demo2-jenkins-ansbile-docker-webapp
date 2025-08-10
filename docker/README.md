## Docker
<img width="2940" height="1912" alt="image" src="https://github.com/user-attachments/assets/a466228e-6905-4efd-bfce-71c2c5585e6f" />

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
