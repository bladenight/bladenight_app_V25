#/bin/sh

#Script for serverpart to create wss certificate from letsencrypt - Script not validated
#  ///usr/local/psa/var/modules/letsencrypt/etc/live/
PASSWORD=$(setAPAssword)
//in tempfolder remove
mkdir ./tempfolder
rm keystore_letsencrypt.jks
rm fullchain_and_key.p12
#copy actual Letsencrypt fullchain.pem and privkey.pem to a tempfolder
cp /usr/local/psa/var/modules/letsencrypt/etc/live/fullchain.pem ./tempfolder/
cp /usr/local/psa/var/modules/letsencrypt/etc/live/privkey.pem ./tempfolder/

openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out fullchain_and_key.p12 -name jetty -password pass:useANewPassWord
keytool -importkeystore -destkeystore keystore_letsencrypt.jks -srckeystore fullchain_and_key.p12 -alias jetty -storepass $PASSWORD
keytool -import -destkeystore keystore_letsencrypt -file chain.pem -alias root -storepass $PASSWORD
cp keystore_letsencrypt.jks /home/bnapp/bladenightserver/config/assets/certs/keystore_letsencrypt.jks
//cleanup tempfolder
rm -r ./tempfolder
chown userroot:usergroup /bladenightserver/config/assets/certs/keystore_letsencrypt.jks