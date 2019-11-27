# AWS IoT Setup 

## 1. X.509 Device certificate,keys,IoT Policy,Thing and Code signing keys

In order to connect succesfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first.

Go to _builder_session_reinvent2019_fr/workshop/tools/_ directory of the git repository and execute **setup.sh** as below,

```
builder_session_reinvent2019_fr/workshop/tools$./create_keys_and_certificate.sh
Certificate Id: 161202e390728e42144cdc969b35b60b358c5dedc2f36f1110820c24a5fc0233
Not printing Private key, stored in privatekey.pem
```

Note down the Certificate Id printed on the console.

The script creates 3 files in the tools directory by making calls to AWS IoT Core in the us-west-2 region,

1. cert.pem (Device certificate)
2. privatekey.pem (Private Key)
3. certificateId (Certificate Id)

The script also activates the certificate, creates an IoT policy, attaches an IoT Policy to the Certificate, creates a Thing and associates the Thing with the Certificate. The following are also created during the script execution,

1. IoT Policy: {certificate-id}-policy
2. Thing name: {certificate-id}-thing

## 2. Code signing keys
To make the OTA process secure the Firmware that will be sent to the device needs to be signed by the Code signing Key on AWS. The Code Signing Certificate is loaded on the device as well to check the firmware is signed by the right key on AWS. 

To automate the creation of the Thing, Certificate, Keys, IoT Policy and the Code signing certificate a script has been provided to you in the **workshop/toools/** directory called **setup.sh**. When you are ready, please execute the script,

$**./create_keys_and_certificate.sh**

Please go through the script to get an understanding of what is going on under the hood. The script also creates a partition.bin file for storing all the Device Certificate,Key and Code-signing certificates. More details on how the partition.bin is generated is covered in the net section of the workshop [Link to next section]


