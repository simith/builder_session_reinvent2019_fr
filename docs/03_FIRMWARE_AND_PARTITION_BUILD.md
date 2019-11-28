
## Factory provisioning
The factory provisioning of the ESP32 module involved provisioning it with AWSI IoT certificates

## The partition table

```
# Name,   Type, SubType, Offset,  Size, Flags
nvs,      data, nvs,     0x10000,  0x6000
otadata,  data, ota,     0x16000,  0x2000
phy_init, data, phy,     0x18000,  0x1000
ota_0,    0,    ota_0,   0x20000,  1500K
ota_1,    0,    ota_1,   ,         1500K
storage,  data, nvs,  ,         0x10000
```

The above partition table represents 2 OTA partitions and (ota_0 and ota_1) and a NVS (non-volatile storage) partition for storing certificates and configuration. The production firmware is flashed at ota_0. You can use code signing through the AWS IoT Device Management console to sign your code images before deploying them using an over-the-air (OTA) update job.


## Creating a Code-Signing Certificate for the Espressif ESP32

###Please note all these steps have been performed already by the ./setup.sh script, it is here for information purposes only.

1. In your working directory, use the following text to create a file named cert_config.txt. Replace test_signer@amazon.com with your email address:

```
[ req ]
prompt             = no
distinguished_name = my_dn

[ my_dn ]
commonName = test_signer@your_domain.com

[ my_exts ]
keyUsage         = digitalSignature
extendedKeyUsage = codeSigning
```

2. Create an ECDSA code-signing private key:
```
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve -outform PEM -out ecdsasigner.key
```

3. Create an ECDSA code-signing certificate:
```
openssl req -new -x509 -config cert_config.txt -extensions my_exts -nodes -days 365 -key ecdsasigner.key -out ecdsasigner.crt
```

4. Import the certificate into ACM (Amazon Certificate Manager)
Note: Show steps to import the certificate to ACM (snapshots already there in docs)

![ACM Dashboard?](acm_dashboard.png)

Paste the contents of the certificate and private key into the text area (created in Step 2 and 3)

![Import certificate](acm_import_certificate.png)

5. Create an IAM policy to grant access to Code signing for AWS IoT
