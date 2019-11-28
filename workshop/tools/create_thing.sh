WORKSHOP_TOOLS_DIR=$WORKSHOP_ROOT_DIR/workshop/tools

# obtain sts token based on the current account
accountId=$(aws sts get-caller-identity | jq .Account | tr -d '"' )
echo "Account ID: ${accountId}"

# create a key, certificate pair.
json_output=$(aws iot create-keys-and-certificate)
$(echo ${json_output} | jq  .certificatePem | sed 's/\\n/\n/g'| tr -d '"'  > cert.pem)
$(echo ${json_output} | jq  .keyPair.PrivateKey | sed 's/\\n/\n/g'| tr -d '"'  > privatekey.pem)
$(echo ${json_output} | jq  .certificateId | sed 's/\\n/\n/g'| tr -d '"'  > certificateId)
certificateArnVar=$(echo ${json_output} | jq  .certificateArn |  sed 's/\\n/\n/g'| tr -d '"' )
certificateIdVar=$(cat certificateId)
echo "Certificate ID: ${certificateIdVar}"
echo "Certificate stored in cert.pem, privatekey in privatekey.pem"
echo $certificateIdVar > certificateId

# updating certificate to active state
echo "Updating certificate state to ACTIVE"
$(aws iot update-certificate --certificate-id ${certificateIdVar} --new-status=ACTIVE)

# creating a policy
$(sed  "s/ACCOUNT_ID/$accountId/g" iot_policy.json.tmpl > iot_policy.json)
echo "Creating IoT Policy with name [${certificateIdVar}-iot-policy]"
$(aws iot create-policy --policy-name "${certificateIdVar}-iot-policy" --policy-document file://iot_policy.json >> policy_created.json)
echo "Attaching IoT Policy [${certificateIdVar}-iot-policy] to certificate"
$(aws iot attach-policy --policy-name "${certificateIdVar}-iot-policy" --target "${certificateArnVar}")

# using certificateID to generate a thingName (ideally it should be unique like a serial number)
thingNameVar=$(cat certificateId | cut -c1-10 | tr [a-z] [A-Z])
echo $thingNameVar > thingName

# create a thing name
echo "Creating Thing with thing name: ${thingNameVar}"
$(aws iot create-thing --thing-name ${thingNameVar} >> create_thing.log)
echo "Attaching Thing with thing name ${thingNameVar} to certificate ${certificateIdVar}"
$(aws iot attach-thing-principal --thing-name "${thingNameVar}" --principal "${certificateArnVar}")
