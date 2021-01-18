# HTTPD Extended 

## HTTPD with Additional Vhost, Basic Authentication and SSL

This is a docker image that is identical to the official httpd image, extended with additional vhost, basic authentication and SSL (https://github.com/techforum-repo/docker-projects/tree/master/httpd-extended)

## Running

**Latest from Docker Hub:**

```sh
docker run --rm --name httpd-extended -p 80:80 -p 443:443 -v /mnt/c/Albin/blogData/docker-projects/httpd-extended/www:/usr/local/apache2/htdocs/ techforum/httpd-extended

```

The sample initial website content is placed in www folder and mounted to /usr/local/apache2/htdocs/, the changes on the files under www folder in host machine will reflect immediately on the server.

**Run From Source:**

Clone the repo(git clone https://github.com/techforum-repo/docker-projects.git) and cd to the httpd-extended ,run the `./build.bash` script.

Run docker run command specified above.


The customized httpd.conf file is placed under the root folder(httpd.conf is copied to /usr/local/apache2/conf/ folder in the container) and the additional customizations are placed under extra folder(the content from extra folder is copied to /usr/local/apache2/conf/extra/ folder in the container) - modify the configurations as required.

The self signed certificate files are placed ssl folder(the content from ssl folder is copied to /usr/local/apache2/conf/ folder in the container).

The intial htpasswd file is place under www folder, the default credential myuser1/welcome1

## Additional Docker Commands


**Verify the containers status**

```
docker ps -a 
docker ps -a -f name=httpd-extended
```

**Restart Container**

```
docker container restart httpd-extended
```

**Stop container**

```
docker container stop httpd-extended
```

**View Container Logs**

```
docker logs httpd-extended
```