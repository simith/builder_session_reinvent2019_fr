# AWS IoT Setup 

Before setting up everything, we need to setup the Workshop Root directory **WORKSHOP_ROOT_DIR** environment variable, from the **builder_session_reinvent2019_fr**,

```
builder_session_reinvent2019_fr$ export WORKSHOP_ROOT_DIR=$PWD
```

## 1. X.509 Device certificate,keys,IoT Policy,Thing and Code signing keys

In order to connect succesfully to AWS IoT and perform an OTA update an X.509 certificate, Private key,IoT Policy and Code  signing certificate is required. We will create this first.

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
2. Thing name: thing

## 2. Code signing
To make the OTA process secure the Firmware that will be sent to the device needs to be signed by the Code signing Key on AWS. The Code Signing Certificate is loaded on the device as well to check the firmware is signed by the right key on AWS. 

The Code signing Certificate and Key have been created by the script for you, however they need to be uploaded to the AWS Cloud for Firmware signing. To upload the certificate and private key to the Amazon Certificate Maneger, please follow the instructions below,

From the **worksop/tools** directory let us use the AWS CLI ACM command to import the certificate,

```
workshop/tools (master)$ aws acm import-certificate --certificate file://ecdsasigner.crt  --private-key file://ecdsasigner.key
```

## 3. Creating an S3 bucket for storing firmware images

Create an S3 bucket using the AWS CLI

```
aws s3 mb s3://<your_new_bucket_name> --region=us-west-2
```


Let us enable versioning on the bucket,

```
aws s3api put-bucket-versioning --bucket <your_new_bucket_name>  --versioning-configuration Status=Enabled
```


## 4. Creating an IAM Policy and a Role for OTA update

For uploading firmware to S3 bucket, sign the firmware and deploy it, we need to create an IAM Policy and attach it to a Role. In this workshop the Role and IAM Policy has been created for you and attached to your IAM username, the following is the IAM policy. ***You do not need to perform this step***.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "acm:ImportCertificate",
                "acm:ListCertificates",
                "iot:*",
                "iam:ListRoles",
                "freertos:ListHardwarePlatforms",
                "freertos:DescribeHardwarePlatform"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "signer:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::ACCOUNT_ID:role/ota-update-reinvent-role"
        }
    ]
}
```

We are all set now for building the firmware image on Cloud 9 and flashing the firmware image and configuration onto the ESP32.


