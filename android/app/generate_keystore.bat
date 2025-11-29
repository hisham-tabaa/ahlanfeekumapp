@echo off
echo Creating upload keystore for Google Play...
keytool -genkey -v -keystore upload-keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000 -storepass android -keypass android -dname "CN=AhlanFeekum, OU=Development, O=AhlanFeekum Inc, L=Unknown, S=Unknown, C=US"
echo Keystore created successfully!