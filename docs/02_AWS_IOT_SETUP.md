## Connecting to AWS IoT

In order to connect succesfully to AWS IoT, a X.509 certificate, Private key and an IoT Policy attached to the Certificate is required. We will create this first.

Go to *builder_session_reinvent2019_fr/workshop/tools/* directory of the git repository and execute **create_keys_and_certificate.sh** as below,

```
builder_session_reinvent2019_fr/workshop/tools$**./create_keys_and_certificate.sh**
161202e390728e4544cdc969b35b60b358c5dedc2f36f11108633c24a5fc0233
Not printing Private key, stored in privatekey.pem
```
