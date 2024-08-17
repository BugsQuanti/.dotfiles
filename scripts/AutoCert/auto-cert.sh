#!/bin/bash
#This script has been used to create self signed certificates for local network. This can helpful since some services forces you for secure reasons to use tls. Also you really dont want use a extra domain which requires any out connections to WAN. 
#WARNING! It is highly recommended to not use self signed certificates for security reasons, use with caution! 

#Generate passphrase.txt file with random generation if not exists
# Filename
FILENAME="passphrase.txt"

# Check if the file exists
if [ ! -f "$FILENAME" ]; then
    # Generate random length between 128 and 256
    LENGTH=$((RANDOM % 129 + 128))

    # Generate random password
    PASSWORD=$(openssl rand -base64 $((LENGTH * 3 / 4)))

    # Save password to the file
    echo "$PASSWORD" > "$FILENAME"

    echo "File '$FILENAME' created with password length $LENGTH."
else
    echo "File '$FILENAME' already exists."
fi


NAME="USER INPUT"
DOMAINNAME="USER INPUT"

read -p "Enter name: " NAME
read -p "Enter local domain name example.: vaultwarden.lan: " DOMAINNAME

#Check if a cert with name exists already. Exit if yes.
if [ -d "$NAME" ]; then
  echo "Directory $NAME does exists already"
 exit 1
fi

mkdir $NAME


openssl genrsa -des3 -out ./$NAME/myCA_$NAME.key -passout file:passphrase.txt 2048

#Create root certificate
openssl req -x509 -new -nodes -key ./$NAME/myCA_$NAME.key -sha256 -days 1825 -passin file:passphrase.txt -out ./$NAME/myCA_$NAME.pem


#Copy myCA.pem
sudo cp ./$NAME/myCA_$NAME.pem /etc/ca-certificates/trust-source/anchors/
sudo trust extract-compat

openssl genrsa -out ./$NAME/$DOMAINNAME.key 2048
openssl req -new -key ./$NAME/$DOMAINNAME.key -out ./$NAME/$DOMAINNAME.csr

cp ./certificate.ext ./$NAME/$DOMAINNAME.ext
echo "DNS.1 = $DOMAINNAME" >> ./$NAME/$DOMAINNAME.ext

openssl x509 -req -in ./$NAME/$DOMAINNAME.csr -CA ./$NAME/myCA_$NAME.pem -CAkey ./$NAME/myCA_$NAME.key -CAcreateserial -out ./$NAME/$DOMAINNAME.crt -days 825 -passin file:passphrase.txt -sha256 -extfile ./$NAME/$DOMAINNAME.ext


echo "In case you use nginx-proxy-manager: Upload $DOMAINNAME.key and $DOMAINNAME.crt as custom certificate on webinterface"
