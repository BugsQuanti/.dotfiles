Self-Signed Certificates for Local Network

This Bash script allows for the easy creation of self-signed certificates for HTTPS connections in a closed LAN environment. It is useful for applications that require a secure connection without the need for an external domain or internet access.
Features

    Generates password-protected private key material.
    Creates a self-signed root certificate.
    Generates a certificate for a specified local domain.
    Supports use with Nginx Proxy Manager.

Usage

    Clone the repository or download the script.
    Ensure OpenSSL is installed.
    Run the script and follow the prompts to enter a name and domain.
    Upload the generated certificates to your application.

Warning

Self-signed certificates are not suitable for use in production environments that connect to the internet. Use them only in closed networks.
