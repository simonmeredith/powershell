#Web application name
$realm = "urn:sharepoint:Portal"
#ADFS signin URL
$signInURL = "https://***********"
$rootCertPath = "D:\Certificates\root.stgldn"
$tokenSigningCertPath = "D:\Certificates\adfs.stgldn"

$rootCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($rootCertPath)
$tokenSigningCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($tokenSigningCertPath)
$providerName = "ADFS"
$providerDescription = "ADFS 2.0 Authentication Provider" 

#Import root CA certificate
New-SPTrustedRootAuthority -Name "Token Signing Cert Parent" -Certificate $rootCert

#Import token signing certificate
New-SPTrustedRootAuthority -Name "Token Signing Cert" -Certificate $tokenSigningCert

#Create new claim mapping for email address
$emailClaimMap = New-SPClaimTypeMapping -IncomingClaimType "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress" -IncomingClaimTypeDisplayName "EmailAddress" -SameAsIncoming

#Create new authentication provider for ADFS
$ap = New-SPTrustedIdentityTokenIssuer -Name $providerName -Description $providerDescription -realm $realm -ImportTrustCertificate $tokenSigningCert -ClaimsMappings $emailClaimMap -SignInUrl $signInURL -IdentifierClaim $emailClaimmap.InputClaimType