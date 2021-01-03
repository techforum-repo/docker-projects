#!/usr/bin/env bash

set -e

. ./bin/functions.bash

add_condition_to_quality_gate()
{
    gate_id=$1
    metric_key=$2
    metric_operator=$3
    metric_errors=$4

    info  "adding AEM/Custom quality gate condition: ${metric_key} ${metric_operator} ${metric_errors}."

    threshold=()
    if [ "${metric_errors}" != "none" ]
    then
        threshold=("--data-urlencode" "error=${metric_errors}")
    fi

    res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "gateId=${gate_id}" \
                --data-urlencode "metric=${metric_key}" \
                --data-urlencode "op=${metric_operator}" \
                "${threshold[@]}" \
                "${SONARQUBE_URL}/api/qualitygates/create_condition")
    if [ "$(echo "${res}" | jq '(.errors | length)')" == "0" ]
    then
        info  "metric ${metric_key} condition successfully added."
    else
        info "Filed to add ${metric_key} condition" "$(echo "${res}" | jq '.errors[].msg')"
    fi
}

create_quality_gate()
{

	info  "creating AEM/Custom quality gate."
	#Modify the quality gate name(AEM) as required
    res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "name=AEM" \
                "${SONARQUBE_URL}/api/qualitygates/create")
    if [ "$(echo "${res}" | jq '(.errors | length)')" == "0" ]
    then
        info  "successfully created AEM/Custom quality gate... now configuring it."
    else
        info "Failed to create quality gate" "$(echo "${res}" | jq '.errors[].msg')"
    fi

    # Retrieve AEM/Custom quality gates ID
    info  "retrieving AEM/Custom quality gate ID."
    res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "name=AEM" \
                "${SONARQUBE_URL}/api/qualitygates/show")
    if [ "$(echo "${res}" | jq '(.errors | length)')" == "0" ]
    then
        GATEID="$(echo "${res}" |  jq -r '.id')"
        info  "successfully retrieved AEM/Custom quality gate ID (ID=$GATEID)."
    else
        error "Failed to reach AEM/Custom quality gate ID" "$(echo "${res}" | jq '.errors[].msg')"
    fi

    # Setting it as default quality gate
    info "setting AEM/Custom quality gate as default gate."
    res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "id=${GATEID}" \
                "${SONARQUBE_URL}/api/qualitygates/set_as_default")
    if [ -z "$res" ]
    then
        info  "successfully set AEM/Custom quality gate as default gate."
    else
        info "Failed to set AEM/Custom quality gate as default gate" "$(echo "${res}" | jq '.errors[].msg')"
    fi

    # Adding all conditions of the JSON file
    info "adding all conditions of aem-quality-gate.json to the gate."
    len=$(jq '(.conditions | length)' conf/aem-quality-gate.json)
    aem_quality_gate=$(jq '(.conditions)' conf/aem-quality-gate.json)
    for i in $(seq 0 $((len - 1)))
    do
        metric=$(echo "$aem_quality_gate" | jq -r '(.['"$i"'].metric)')
        op=$(echo "$aem_quality_gate" | jq -r '(.['"$i"'].op)')
        error=$(echo "$aem_quality_gate" | jq -r '(.['"$i"'].error)')
        add_condition_to_quality_gate "$GATEID" "$metric" "$op" "$error"
    done
}


create_quality_profiles()
{
    info  "creating Quality Profile."
	
	#Change the custom quality profile id(aem-way-java) based on your need
	
    res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "language=java" \
				--data-urlencode "name=aem-way-java" \
                "${SONARQUBE_URL}/api/qualityprofiles/create")
    if [ "$(echo "${res}" | jq '(.errors | length)')" == "0" ]
    then
        info  "successfully created quality profile."
    else
        info "Failed to create quality profile" "$(echo "${res}" | jq '.errors[].msg')"
    fi
	
	info "Change Parent to quality Profile"
	
	res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "language=java" \
				--data-urlencode "parentQualityProfile=Sonar way" \
				--data-urlencode "qualityProfile=aem-way-java" \
                "${SONARQUBE_URL}/api/qualityprofiles/change_parent")
    if [ -z "$res" ]
    then
        info  "successfully changed parent to the quality profile."
    else
        info "Failed to change parent to the quality profile" "$(echo "${res}" | jq '.errors[].msg')"
    fi
	
		
	info "Setting Default Quality Profile"
	
	res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "language=java" \
				--data-urlencode "qualityProfile=aem-way-java" \
                "${SONARQUBE_URL}/api/qualityprofiles/set_default")
    if [ -z "$res" ]
    then
        info  "successfully set default quality profile."
    else
        info "Failed to set default quality profile" "$(echo "${res}" | jq '.errors[].msg')"
    fi
	
	
	 # Retrieve AEM/Custom quality profile ID
    info  "retrieving AEM/Custom quality profile ID."
    res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "qualityProfile=aem-way-java" \
                "${SONARQUBE_URL}/api/qualityprofiles/search")
    if [ "$(echo "${res}" | jq '(.errors | length)')" == "0" ]
    then
        PROFILEID="$(echo "${res}" |  jq -r '.profiles[].key')"
        info  "successfully retrieved AEM/Custom quality profile ID (ID=$PROFILEID)."
    else
        error "Failed to reterive AEM/Custom quality profile ID" "$(echo "${res}" | jq '.errors[].msg')"
    fi
	
	info "Activating AEM Rules"
	
	#Modify the custom rule repository id's based on your custom plugin configuration
	
	res=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
                --data-urlencode "repositories=AEM Rules,Common HTL,custom-project-rules," \
				--data-urlencode "targetKey=${PROFILEID}" \
                "${SONARQUBE_URL}/api/qualityprofiles/activate_rules")
    if [ "$(echo "${res}" | jq '(.errors | length)')" == "0" ]
    then
        info  "successfully activated AEM rules."
    else
        info "Failed to activate AEM rules" "$(echo "${res}" | jq '.errors[].msg')"
    fi
	
}

# End of functions definition
# ============================================================================ #
# Start script

# Wait for SonarQube to be up
wait_sonarqube_up

# Make sure the database has not already been populated
status=$(curl -i -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
            "${SONARQUBE_URL}/api/qualitygates/list" \
    | sed -n -r -e 's/^HTTP\/.+ ([0-9]+)/\1/p')
status=${status:0:3} # remove \n
nb_qg=$(curl -su "admin:$SONARQUBE_ADMIN_PASSWORD" \
            "${SONARQUBE_URL}/api/qualitygates/list" \
    | jq '.qualitygates | map(select(.name == "AEM")) | length')
if [ "$status" -eq 200 ] && [ "$nb_qg" -eq 1 ]
then
    # admin password has already been changed and the AEM QG has already been added
    info  "The database has already been filled with AEM configuration. Not adding anything."
else
    # Change admin password
    curl -su "admin:admin" \
        --data-urlencode "login=admin" \
        --data-urlencode "password=$SONARQUBE_ADMIN_PASSWORD" \
        --data-urlencode "previousPassword=admin" \
        "$SONARQUBE_URL/api/users/change_password"
    info  "admin password changed."

    # Add GPs and rules
    create_quality_profiles

    # Add QG
    create_quality_gate
fi

# Tell the user, we are ready
info "ready!"

exit 0