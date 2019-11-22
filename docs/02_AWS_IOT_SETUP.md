## 1. X.509 Device certificate and keys to connect to AWS IoT

In order to connect succesfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first.

Go to *builder_session_reinvent2019_fr/workshop/tools/* directory of the git repository and execute **create_keys_and_certificate.sh** as below,

```
builder_session_reinvent2019_fr/workshop/tools$./create_keys_and_certificate.sh
Certificate Id: 161202e390728e42144cdc9x9b35b60b358c5dedc2f36f11108xxc24a5fc0233
Not printing Private key, stored in privatekey.pem
```

Note down the Certificate Id printed on the console.

The script creates 3 files in the tools directory by making calls to AWS IoT Core in the us-west-2 region, 

1. cert.pem (Device certificate)
2. privatekey.pem (Private Key)
3. certificateId (Certificate Id)

## 2. Activate the AWS IoT Device certificate
Head to the AWS IoT Console (us-west-2), and from the sidebar, select Secure, copy the Certificate Id from the output of the **create_keys_and_certificate.sh** and paste it into the searchbox,

!(find_certificate.png)



