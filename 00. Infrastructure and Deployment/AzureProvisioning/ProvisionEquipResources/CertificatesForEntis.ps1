Get-ChildItem -Path “Cert:\CurrentUser\My”
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My\688166EC0332C4F8D8D5489A48031D48097334A8"

New-SelfSignedCertificate -Type Custom -KeySpec Signature -Subject "CN=P2SChildCert" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My" -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")