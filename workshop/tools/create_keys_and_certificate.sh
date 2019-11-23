

workshop_tools_dir=$(pwd)
workshop_esp32_partition_writer_dir=../../amazon-freertos/vendors/espressif-espressif-idf/components/ \
nvs_flash/nvs_partition_generator/

json_output=$(aws iot create-keys-and-certificate)

$(echo ${json_output} | jq  .certificatePem | sed 's/\\n/\n/g'| tr -d '"'  > cert.pem)
$(echo ${json_output} | jq  .keyPair.PrivateKey | sed 's/\\n/\n/g'| tr -d '"'  > privatekey.pem)
$(echo ${json_output} | jq  .certificateId | sed 's/\\n/\n/g'| tr -d '"'  > certificateId)
certificateIdVar=$(cat certificateId)
echo "Certificate Id: ${certificateIdVar}"
echo "[OK]] Certitficate stored in cert.pem, privatekey in privatekey.pem"

# creae a code signing certificate
echo "Creating Code signing Key and Certificate"
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve -outform PEM -out ecdsasigner.key
openssl req -new -x509 -config code_signing_cert_config.txt -extensions my_exts -nodes -days 365 -key ecdsasigner.key -out ecdsasigner.crt

# Create PEM to DER conversion
echo "Converting certificate,private key and code signing key from PEM to DER format"
openssl rsa -inform PEM -outform der   <privatekey.key >privatekey.der
openssl x509 -outform der -in cert.pem -out cert.der
openssl x509 -outform der -in ecdsasigner.crt -out csk.der

echo "Copying certificate,private key and code signing key to ${workshop_esp32_partition_writer_dir}"
cp privatekey.der cert.der csk.der ${workshop_esp32_partition_writer_dir}
cd ${workshop_esp32_partition_writer_dir}
echo "Creating partition.bin with Key, Device certificate and Code signing certificate"
python  nvs_partition_gen.py  --version v2 ./partition.csv partition.bin
cp partition.bin ${workshop_tools_dir}
echo "Updating certificate state to ACTIVE"
$(aws iot update-certificate --certificate-id ${certificateIdVar} --new-status=ACTIVE)
echo "Creating IoT Policy with name [${certificateIdVar}-iot-policy]"
$(aws iot create-policy --policy-name ${certificateIdVar}-iot-policy --policy-document file://iot_policy.json)
echo "Attaching IoT Policy [${certificateIdVar}-iot-policy] to certificate ${certificateIdVar}"
$(aws iot attach-policy --polcy-name ${certificateIdVar}-iot-policy --target ${certificateIdVar})
echo "Creating Thing with thing name ${certificateIdVar}-thing"
$(aws iot create-thing ${certificateIdVar}-thing)
echo "Attaching Thing with thing name ${certificateIdVar}-thing to to certificate ${certificateIdVar}"
$(aws iot attach-thing-principal --thing-name ${certificateIdVar}-thing --principal ${certificateIdVar})
cd ${workshop_tools_dir}
echo "partition.bin copied to ${workshop_tools_dir}, ready for download"

