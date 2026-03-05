# Spec: SSL Keylog

## Purpose

The SSL Keylog capability allows OpenResty to log TLS session secrets to a file specified by an environment variable. This enables traffic decryption and analysis using tools like Wireshark.

## Requirements

### Requirement: Write SSL Key Log
The system SHALL write TLS session secrets to the file specified by the `SSLKEYLOGFILE` environment variable if it is set.

#### Scenario: Environment variable set
- **WHEN** the `SSLKEYLOGFILE` environment variable is set to a writable file path
- **AND** Nginx is started
- **AND** an HTTPS connection is established
- **THEN** the specified file SHALL contain the TLS session secrets

#### Scenario: Environment variable not set
- **WHEN** the `SSLKEYLOGFILE` environment variable is NOT set
- **AND** Nginx is started
- **THEN** Nginx SHALL NOT write any key log file
- **AND** Nginx SHALL start normally without errors

#### Scenario: File not writable
- **WHEN** the `SSLKEYLOGFILE` environment variable is set to a path that is not writable (e.g., directory permission denied)
- **AND** Nginx is started
- **THEN** Nginx SHALL log an error to the error log (or standard error) indicating failure to open the key log file
- **AND** Nginx SHALL continue to process requests (soft failure preferred, or hard failure if OpenSSL dictates)
