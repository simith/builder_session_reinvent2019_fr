# AWS IoT Setup 

Before setting up everything, we need to setup the Workshop Root directory, from the builder_session_reinvent2019_fr,

**builder_session_reinvent2019_fr**$export WORKSHOP_ROOT_DIR=$PWD


## 1. X.509 Device certificate,keys,IoT Policy,Thing and Code signing keys

In order to connect succesfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first.

cd to **builder_session_reinvent2019_fr/workshop/tools/** directory of the git repository and execute **setup.sh** as below,

```
iot_dev_009:~/environment/builder_session_reinvent2019_fr/workshop/tools (master) $ ./setup.sh 
Account id: 24786XXXXX504
arn:aws:iot:us-west-2:24786XXXXX504:cert/856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0
Certificate Id: 856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0
[OK]] Certitficate stored in cert.pem, privatekey in privatekey.pem
856249658C
Creating Code signing Key and Certificate
Converting certificate,private key and code signing key from PEM to DER format
writing RSA key
Copying certificate,private key and code signing key to /home/ubuntu/environment/builder_session_reinvent2019_fr/workshop/amazon-freertos/vendors/espressif/esp-idf/components/nvs_flash/nvs_partition_generator/testdata
Creating partition.bin with Key, Device certificate and Code signing certificate
row[key]{'type': 'namespace', 'value': '', 'key': 'creds', 'encoding': ''}
row[key]{'type': 'file', 'value': 'testdata/cert.der', 'key': 'P11_Cert', 'encoding': 'binary'}
row[key]{'type': 'file', 'value': 'testdata/privatekey.der', 'key': 'P11_Key', 'encoding': 'binary'}
row[key]{'type': 'file', 'value': 'testdata/csk.der', 'key': 'P11_CSK', 'encoding': 'binary'}
Copying partition.bin in /home/ubuntu/environment/builder_session_reinvent2019_fr/workshop/amazon-freertos/vendors/espressif/esp-idf/components/nvs_flash/nvs_partition_generator/testdata to Workshop Tools directory /home/ubuntu/environment/builder_session_reinvent2019_fr/workshop/tools
Updating certificate state to ACTIVE
Creating IoT Policy with name [856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0-iot-policy]
Attaching IoT Policy [856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0-iot-policy] to certificate arn:aws:iot:us-west-2:24786XXXXX504:cert/856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0
Creating Thing with thing name: 856249658C
Attaching Thing with thing name 856249658C to to certificate 856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0
partition.bin copied to /home/ubuntu/environment/builder_session_reinvent2019_fr/workshop/tools, ready for download
iot_dev_009:~/environment/builder_session_reinvent2019_fr/workshop/tools (master) $ 

```
The sample output from above prints a few thing,

CertificateId: **856249658c439b3808d62ac8eed5784ee12d5f8d36702a5e69282fa0f645f7c0**

The Certificate Id is the id of the Device certificate on AWS IoT Core.

The script creates a few files on disk in the tools directory by making calls to AWS IoT Core in the us-west-2 region,

1. cert.pem (Device certificate)
2. privatekey.pem (Private Key)
3. certificateId (Certificate Id)

The script also activates the certificate, creates an IoT policy, attaches an IoT Policy to the Certificate, creates a Thing and associates the Thing with the Certificate on AWS IoT Core. The following are also created during the script execution,

1. IoT Policy: {certificate-id}-policy
2. Thing name: {certificate-id}-thing

## 2. Code signing
To make the OTA process secure the Firmware that will be sent to the device needs to be signed by the Code signing Key on AWS. The Code Signing Certificate is loaded on the device as well to check the firmware is signed by the right key on AWS. 

The Code signing Certificate and Key have been created by the script for you, however they need to be uploaded to the AWS Cloud for Firmware signing. To upload the certificate and private key to the Amazon Certificate Maneger, please follow the instructions below,

From the **worksop/tools** directory let us use the AWS CLI ACM command to import the certificate,

```
workshop/tools (master) $ aws acm import-certificate --certificate file://ecdsasigner.crt  --private-key file://ecdsasigner.key
```



$**./setup.sh**

Please go through the script to get an understanding of what is going on under the hood. The script also creates a partition.bin file for storing all the Device Certificate,Key and Code-signing certificates. More details on how the partition.bin is generated is covered in the net section of the workshop [Link to next section]


