# AWS IoT Setup

## 1. X.509 Device Certificate, Keys, IoT Policy and Thing

In order to connect successfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first.

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
Attaching Thing with thing name <THING_NAME> to certificate 81ba243aa45f857fe369701287caff639cd363edb372b50bb943d3a5cfd4421b
```

Note down the Certificate ID printed on the console.

The script creates 3 files in the tools directory by making calls to AWS IoT Core in the us-west-2 region,

1. cert.pem (Device Certificate)
2. privatekey.pem (Private Key)
3. certificateId (Certificate ID)

The script also activates the certificate, creates an IoT policy, attaches an IoT Policy to the Certificate, creates a Thing and associates the Thing with the Certificate. The following are also created during the script execution,

1. iot_policy.json (IoT Policy)
2. thingName (Thing Name)

## 2. Generating Code Signing Keys and Certificates
To make the OTA process secure the Firmware that will be sent to the device needs to be signed by the Code signing Key on AWS. The Code Signing Certificate is loaded on the device as well to check the firmware is signed by the right key on AWS.

To automate the creation of the Thing, Certificate, Keys, IoT Policy and the Code signing certificate a script has been provided to you in the **workshop/tools/** directory called **create_code_signing_cert.sh**. When you are ready, please execute the script,

```
$ ./create_code_signing_cert.sh**
Creating Code Signing Key and Certificate
```

The script generates a key and certificate that will be used for code signing.

1. ecdsasigner.key (Signing Key)
2. ecdsasigner.crt (Public Certificate)

Please go through the script to get an understanding of what is going on under the hood.

Click [here](./03_FIRMWARE_AND_PARTITION_BUILD.md) to continue to the next section.
