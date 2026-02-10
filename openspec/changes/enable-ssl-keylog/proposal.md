<!-- Use this as the structure for your output file. Fill in the sections. -->  
## Why

We need to enable `SSLKEYLOGFILE` support in Nginx/OpenResty to allow developers and operations engineers to decrypt and analyze HTTPS traffic using tools like Wireshark. This is crucial for debugging production issues and understanding traffic patterns without compromising the server's private key security or performing man-in-the-middle attacks.

## What Changes

- Add a patch to Nginx core source code (`src/event/ngx_event_openssl.c`) to support the `SSLKEYLOGFILE` environment variable.
- When the `SSLKEYLOGFILE` environment variable is set, Nginx will write TLS session secrets to the specified file.
- This change will be applied via the existing build system using a patch file.

## Capabilities

### New Capabilities
<!-- Capabilities being introduced. Replace <name> with kebab-case identifier (e.g., user-auth, data-export, api-rate-limiting). Each creates specs/<name>/spec.md -->
- `ssl-keylog`: Supports logging SSL/TLS session keys to a file specified by the `SSLKEYLOGFILE` environment variable for traffic decryption.

### Modified Capabilities
<!-- Existing capabilities whose REQUIREMENTS are changing (not just implementation).
     Only list here if spec-level behavior changes. Each needs a delta spec file.
     Use existing spec names from openspec/specs/. Leave empty if no requirement changes. -->

## Impact

- **Affected Code**: `src/event/ngx_event_openssl.c` (via patch).
- **Security**: This feature allows decryption of traffic. It requires access to the server environment to set the variable, but documentation should warn about the security implications of enabling this in production.
- **Performance**: Writing key logs to disk may have a negligible performance impact, but should only be enabled when debugging.
