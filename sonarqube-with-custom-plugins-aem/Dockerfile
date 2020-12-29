# This image is based on a LTS version of SonarQube
FROM sonarqube:8.6.0-community

LABEL maintainer="admin@albinsblog.com"

HEALTHCHECK --interval=5m --start-period=2m \
    CMD test $(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" ${SONARQUBE_URL:-http://localhost:9000}/api/system/health | jq '(.health)') = '"GREEN"'

USER root

ADD VERSION .

# Download SonarQube plugins
ADD https://github.com/techforum-repo/projects/releases/download/latest/sonar-custom-project-rules-1.0.0.jar \
    https://github.com/Cognifide/AEM-Rules-for-SonarQube/releases/download/v1.3/sonar-aemrules-plugin-1.3.jar \
    /opt/sonarqube/extensions/plugins/

# Install tools

RUN apk update && \
    apk add --no-cache curl \
	jq

# Copy the config files and scripts into the image
COPY conf/* conf/
COPY scripts/* bin/

# Configure SonarQube
RUN chown -R sonarqube:sonarqube bin/ conf/ extensions/ \
    && chmod u+x -R bin/ \
    # Disable SonarQube telemetry
    && sed -i 's/#sonar\.telemetry\.enable=true/sonar\.telemetry\.enable=false/' /opt/sonarqube/conf/sonar.properties

# Switch back to an unpriviledged user
USER sonarqube

CMD [ "./bin/entrypoint.bash" ]