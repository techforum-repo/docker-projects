# SonarQube with Custom Rules - AEM

This is a docker image that is identical to the official [sonarqube docker image](https://github.com/SonarSource/docker-sonarqube/blob/abaf14c38297974eb5de295d42e83066ddb84751/7.7-community/Dockerfile) with an added script to install AEM-Rules-for-SonarQube(https://github.com/Cognifide/AEM-Rules-for-SonarQube) and custom Project Specific(https://github.com/techforum-repo/projects/tree/main/sonar-custom-project-rules) extensions.

## Running

**Latest from Docker Hub:**

```sh
docker run --rm --name sonarqube -p 9000:9000 -e SONARQUBE_ADMIN_PASSWORD="Welcome1" techforum/sonarqube-with-custom-plugins-aem:latest

```

To persist the data and logs to the host system:

```sh
docker run --rm --name sonarqube -p 9000:9000 -v /mnt/c/Albin/blogData/docker-container-files/data:/opt/sonarqube/data -v /mnt/c/Albin/blogData/docker-container-files/logs:/opt/sonarqube/logs -e SONARQUBE_ADMIN_PASSWORD="Welcome1" techforum/sonarqube-with-custom-plugins-aem:latest

```

Specify the password, the latest SonarQube versions require to change the password on first login, the scripts will automatically update the password(provide in the docker run command).

**Run From Source:**

Clone the repo(git clone https://github.com/techforum-repo/docker-projects.git) and cd to the sonarqube-with-custom-plugins-aem ,run the `./build.bash` script.

Run one of the docker run command specified above.

## Quality Gates

Enable quality gates with some of the required conditions, also enable quality profile with AEM and Custom Project rules, refer `scrips/configure.bash`

Configure the quality gate conditions in conf/aem-quality-gate.json

```
{
  "id": 1,
  "name": "AEM",
  "conditions": [
    { "id": 2, "metric": "blocker_violations", "op": "GT", "error": "0" },
    { "id": 3, "metric": "comment_lines_density", "op": "LT", "error": "20" },
    { "id": 4, "metric": "critical_violations", "op": "GT", "error": "0" },
    { "id": 5, "metric": "duplicated_lines_density", "op": "GT","error": "10"},
    { "id": 6, "metric": "new_duplicated_lines", "op": "GT", "error": "0" },
    { "id": 7, "metric": "major_violations", "op": "GT", "error": "0" },
    { "id": 8, "metric": "new_violations", "op": "GT", "error": "0" },
    { "id": 9, "metric": "new_sqale_debt_ratio", "op": "GT", "error": "0" },
    { "id": 10, "metric": "sqale_debt_ratio", "op": "GT", "error": "5" },
    { "id": 11, "metric": "coverage", "op": "LT", "error": "75" },
    { "id": 12, "metric": "code_smells", "op": "GT", "error": "1" },
    { "id": 13, "metric": "sqale_rating", "op": "GT", "error": "1" },
    { "id": 14, "metric": "reliability_rating", "op": "GT", "error": "1" },
    { "id": 15, "metric": "security_rating", "op": "GT", "error": "1" }
  ]
}

```
## Additional Docker Commands


**Verify the containers status**

```
docker ps -a 
docker ps -a -f name=sonarqube
```

**Restart Container**

```
docker container restart sonarqube
```

**Stop container**

```
docker container stop sonarqube
```

**View Container Logs**

```
docker logs sonarqube
```

## To run the sonarqube with external database(postgres)

The required configurations are enabled in docker-compose.yml file, execute the below commands

```
sudo sysctl -w vm.max_map_count=262144   ( maximum number of memory map areas for VM)
docker-compose up
```