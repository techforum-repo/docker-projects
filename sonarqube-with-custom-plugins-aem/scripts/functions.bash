#!/usr/bin/env bash

# This file contains all the useful functions
# used to configure the SonarQube instance.

# Constants
if [ -z "$SONARQUBE_URL" ]
then
    SONARQUBE_URL="http://localhost:9000"
fi


info () {
  printf "\e[1;34m[Configuration]:: %s ::\e[0m\n" "$*"
}

error () {
  printf "\e[1;31m[Configuration.bash]:: %s ::\e[0m\n" "$*"
}


wait_sonarqube_up()
{
    sonar_status="DOWN"
    info  "initiating connection with SonarQube."
    sleep 15
    while [ "${sonar_status}" != "UP" ]
    do
        sleep 5
        info  "retrieving SonarQube's service status."
        sonar_status=$(curl -s -X GET "${SONARQUBE_URL}/api/system/status" | jq -r '.status')
        info  "SonarQube is ${sonar_status}, expecting it to be UP."
    done
    info  "SonarQube is ${sonar_status}."
}
