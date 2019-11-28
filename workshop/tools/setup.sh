ESP_IDF=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos/vendors/espressif/esp-idf
WORKSHOP_TOOLS_DIR=$WORKSHOP_ROOT_DIR/workshop/tools
WORKSHOP_FREERTOS_DIR=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos
WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR=$WORKSHOP_FREERTOS_DIR/vendors/espressif/esp-idf/components/nvs_flash/nvs_partition_generator
WORKSHOP_PARTITION_WRITER_DIR=$WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR/testdata

accountId=$(aws sts get-caller-identity | jq .Account | tr -d '"' )
echo "Account id: ${accountId}"

json_output=$(aws iot create-keys-and-certificate)
$(echo ${json_output} | jq  .certificatePem | sed 's/\\n/\n/g'| tr -d '"'  > cert.pem)
$(echo ${json_output} | jq  .keyPair.PrivateKey | sed 's/\\n/\n/g'| tr -d '"'  > privatekey.pem)
$(echo ${json_output} | jq  .certificateId | sed 's/\\n/\n/g'| tr -d '"'  > certificateId)
certificateArnVar=$(echo ${json_output} | jq  .certificateArn |  sed 's/\\n/\n/g'| tr -d '"' )
echo ${certificateArnVar}
certificateIdVar=$(cat certificateId)
echo "Certificate Id: ${certificateIdVar}"
echo "[OK] Certitficate stored in cert.pem, privatekey in privatekey.pem"

# print out the thing name
thingName=$(cat certificateId | cut -c1-10 | tr [a-z] [A-Z])
echo $thingName > thingName

# create a code signing certificate
echo "Creating Code Signing Key and Certificate"
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve -outform PEM -out ecdsasigner.key
openssl req -new -x509 -config code_signing_cert_config.txt -extensions my_exts -nodes -days 365 -key ecdsasigner.key -out ecdsasigner.crt

# Create PEM to DER conversion
echo "Converting Certificate, Private Key and Code Signing Key from PEM to DER format"
openssl rsa -inform PEM -outform der   <privatekey.pem >privatekey.der
openssl x509 -outform der -in cert.pem -out cert.der
openssl x509 -outform der -in ecdsasigner.crt -out csk.der

echo "Copying Certificate, Private Key and Code Signing Key to ${WORKSHOP_PARTITION_WRITER_DIR}"
cp privatekey.der cert.der csk.der ${WORKSHOP_PARTITION_WRITER_DIR}
cd ${WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR}

echo "Creating partition.bin with Key, Device certificate and Code signing certificate"
python nvs_partition_gen.py  --version v2 --input partition.csv --output partition.bin
echo "Copying partition.bin in ${WORKSHOP_PARTITION_WRITER_DIR} to Workshop Tools directory ${WORKSHOP_TOOLS_DIR}"
cp ${WORKSHOP_PARTITION_WRITER_DIR}/partition.bin ${WORKSHOP_TOOLS_DIR}/partition.bin

cd ${WORKSHOP_TOOLS_DIR}
echo "Updating certificate state to ACTIVE"
$(aws iot update-certificate --certificate-id ${certificateIdVar} --new-status=ACTIVE)

$(sed  "s/ACCOUNT_ID/$accountId/g" iot_policy.json.tmpl > iot_policy.json)

echo "Creating IoT Policy with name [${certificateIdVar}-iot-policy]"
$(aws iot create-policy --policy-name "${certificateIdVar}-iot-policy" --policy-document file://iot_policy.json >> policy_created.json)
echo "Attaching IoT Policy [${certificateIdVar}-iot-policy] to certificate ${certificateArnVar}"

$(aws iot attach-policy --policy-name "${certificateIdVar}-iot-policy" --target "${certificateArnVar}")
echo "Creating Thing with thing name: ${thingName}"
$(aws iot create-thing --thing-name ${thingName} >> create_thing.log)
echo "Attaching Thing with thing name ${thingName} to to certificate ${certificateIdVar}"
$(aws iot attach-thing-principal --thing-name "${thingName}" --principal "${certificateArnVar}")
cd ${WORKSHOP_TOOLS_DIR}
echo "partition.bin copied to ${WORKSHOP_TOOLS_DIR}, ready for download"
