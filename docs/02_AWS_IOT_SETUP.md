# AWS IoT Setup

### 1. Create X.509 Device Certificate, Keys, Code sigining certificate, IoT Policy and Thing

In order to connect successfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first via a script.

Go to _builder_session_reinvent2019_fr/workshop/tools/_ directory of the git repository and execute **create_thing.sh** as below,

```
$ ./create_thing.sh
Account ID: <ACCOUNT_ID>
Certificate ID: <CERTIFICATE_ID>
Certificate stored in cert.pem, privatekey in privatekey.pem
Updating certificate state to ACTIVE
Creating IoT Policy with name [<CERTIFICATE_ID>-iot-policy]
Attaching IoT Policy [<CERTIFICATE_ID>-iot-policy] to certificate
Creating Thing with thing name: <THING_NAME>
Attaching Thing with thing name <THING_NAME> to certificate <CERTIFICATE_ID>
```

The script creates 3 files in the tools directory by making calls to AWS IoT Core in the us-west-2 region,

1. cert.pem (Device Certificate)
2. privatekey.pem (Private Key)
3. certificateId (Certificate ID)

The script also activates the certificate, creates an IoT policy, attaches an IoT Policy to the Certificate, creates a Thing and associates the Thing with the Certificate. The following files are also created during the script execution,

1. iot_policy.json (IoT Policy)
2. thingName (Thing Name)

At this point, please navigate to the AWS Console > AWS IoT > Manage > Things to find your thing. See how the thing is setup. If you would like to know your Thing name, it will be printed during the above script execution, or you could look at the thingName file to find your thing name. The thing has a Certificate, and the certificate is setup with an IoT Policy for receiving a Job and doing an OTA update.

## 2. Generating Code Signing Keys and Certificates

To make the OTA process secure the Firmware that will be sent to the device needs to be signed by the Code signing Key on AWS. The Code Signing Certificate is loaded on the device as well to check the firmware is signed by the right key on AWS.

To automate the creation of the Thing, Certificate, Keys, IoT Policy and the Code signing certificate a script has been provided to you in the **workshop/tools/** directory called **create_code_signing_cert.sh**. When you are ready, please execute the script,

```
$ ./create_code_signing_cert.sh
Creating Code Signing Key and Certificate
```

The script generates a key and certificate that will be used for code signing.

1. ecdsasigner.key (Signing Key)
2. ecdsasigner.crt (Public Certificate)

Please go through the script to get an understanding of what is going on under the hood. Now that the code signing certificate and key have been created, they need to be uploaded to the AWS Cloud for Firmware signing. To upload the certificate and private key to the Amazon Certificate Manager, please follow the instructions below,

From the **workshop/tools** directory let us use the AWS CLI ACM command to import the certificate,

```
$ aws acm import-certificate --certificate file://ecdsasigner.crt  --private-key file://ecdsasigner.key 2>&1 | tee  acmCertificateId
{
    "CertificateArn": "arn:aws:acm:us-west-2:<ACCOUNT_ID>:certificate/<GUID>"
}
```

The **acmCertificateId** file will have the certificate id for the Code signing certificate, we will need to select it in the OTA Job workflow when we push an OTA update to the Kakematic device.

## 3. Creating an S3 bucket for storing firmware images

First let us create a unique name for your S3 bucket. Let us do the following

```
<BUCKET_NAME> : account-id-<ACCOUNT_ID>-<SOME_RANDOM_STRING>
```

Let us create an S3 bucket for storing the firmware image when we do an OTA update.

Create an S3 bucket using the AWS CLI using the following command.

```
$ aws s3 mb s3://<BUCKET_NAME> --region=us-west-2
```

And then enable versioning on the bucket.

```
$ aws s3api put-bucket-versioning --bucket <BUCKET_NAME>  --versioning-configuration Status=Enabled
```

## 4. Creating an IAM Policy and a Role for OTA update

**_Note you do not need to perform this step_**
For uploading firmware to S3 bucket, sign the firmware and deploy it, we need to create an IAM Policy and attach it to a Role. In this workshop the Role and IAM Policy has been created for you and attached to your IAM username, the following is the IAM policy.

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

| [Previous section](./01_CLOUD_INIT.md) | [Main](../README.md) | [Next section](./03_FIRMWARE_AND_PARTITION_BUILD.md) |
