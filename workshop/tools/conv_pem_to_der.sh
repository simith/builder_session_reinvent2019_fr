# Create PEM to DER conversion
echo "Converting Certificate, Private Key and Code Signing Key from PEM to DER format"
openssl rsa -inform PEM -outform der <privatekey.pem >privatekey.der
openssl x509 -outform der -in cert.pem -out cert.der
openssl x509 -outform der -in ecdsasigner.crt -out csk.der
