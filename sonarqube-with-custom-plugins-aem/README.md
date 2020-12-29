# SonarQube with Custom Rules - AEM

This is a docker image that is identical to the official [sonarqube docker image](https://github.com/SonarSource/docker-sonarqube/blob/abaf14c38297974eb5de295d42e83066ddb84751/7.7-community/Dockerfile) with an added script to install AEM-Rules-for-SonarQube(https://github.com/Cognifide/AEM-Rules-for-SonarQube) and custom Project Specific(https://github.com/techforum-repo/projects/tree/main/sonar-custom-project-rules) extensions.

## Running

Latest from Docker Hub:

```sh
docker run --rm -p 9000:9000 -e SONARQUBE_ADMIN_PASSWORD="Welcome1" techforum/sonarqube-with-custom-plugins-aem:latest

```

To persist the data and logs to the host system:

```sh
docker run --rm -p 9000:9000 -v /mnt/c/Albin/blogData/docker-container-files/data:/opt/sonarqube/data -v /mnt/c/Albin/blogData/docker-container-files/logs:/opt/sonarqube/logs -e SONARQUBE_ADMIN_PASSWORD="Welcome1" techforum/sonarqube-with-custom-plugins-aem:latest

```

Specify the password, the latest SonarQube versions require to change the password on first login, the scripts will automatically update the password(provide in the docker run command).

Run From Source:

Clone the repo(git clone https://github.com/techforum-repo/docker-projects.git) and cd to the sonarqube-with-custom-plugins-aem ,run the `./build.bash` script.

Run one of the docker run command specified above.

## Quality Gates

Enable quality gates with some of the required conditions, also enable quality profile with AEM and Custom Project rules, refer `scrips/configure.bash`