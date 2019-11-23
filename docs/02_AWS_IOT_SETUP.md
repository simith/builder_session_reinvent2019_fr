## 1. X.509 Device certificate and keys to connect to AWS IoT

In order to connect succesfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first.

Go to _builder_session_reinvent2019_fr/workshop/tools/_ directory of the git repository and execute **create_keys_and_certificate.sh** as below,

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

The script also activates the certificate, creates an IoT policy, attaches an IoT Policy to the Certificate, creates a Thing and associates the Thing with the Certificate.

IoT Policy: {certificate-id}-policy
Thing name: {certificate-id}-thing
