json_output=$(aws iot create-keys-and-certificate)
echo $json_output

certificate=$(echo ${json_output} | jq  .certificatePem | sed 's/\\n/\n/g'| tr -d '"'  > cert.pem)
privatekey=$(echo ${json_output} | jq  .keyPair.PrivateKey | sed 's/\\n/\n/g'| tr -d '"'  > privatekey.pem)
certificateId=$(echo ${json_output} | jq  .certificateId | sed 's/\\n/\n/g'| tr -d '"'  > certificateId)
echo $certificate
echo "Not printing Private key, stored in privatekey.pem"
