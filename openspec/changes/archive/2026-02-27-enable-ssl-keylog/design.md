<!-- Use this as the structure for your output file. Fill in the sections. -->
## Context

Currently, OpenResty/Nginx does not natively support logging SSL/TLS session keys to a file. This limitation makes it difficult to decrypt and analyze HTTPS traffic for debugging purposes using tools like Wireshark. Developers often need to inspect the decrypted traffic to diagnose protocol-level issues or verify application behavior.

Standard browsers (Chrome, Firefox) and tools (Curl) support the `SSLKEYLOGFILE` environment variable to dump these keys. Adding this support to OpenResty brings it in line with common debugging practices and provides a powerful diagnostic capability.

## Goals / Non-Goals

**Goals:**
- Enable Nginx/OpenResty to detect the `SSLKEYLOGFILE` environment variable at startup.
- Register a callback with OpenSSL to capture session secrets.
- Write these secrets to the file specified in the environment variable.
- Ensure the implementation is minimally invasive and only active when the environment variable is set.

**Non-Goals:**
- Configuring key logging via `nginx.conf` directives (we will stick to the standard environment variable approach).
- Supporting key logging for OpenSSL versions that do not support `SSL_CTX_set_keylog_callback` (OpenSSL < 1.1.1).
- Managing log rotation for the key log file (this is a debugging tool, not a production audit log).

## Decisions

**1. Use OpenSSL `SSL_CTX_set_keylog_callback` API**
We will use the standard `SSL_CTX_set_keylog_callback` provided by OpenSSL 1.1.1+.
*   **Rationale:** This is the supported, stable API for this purpose. It handles the extraction of the correct secrets automatically.
*   **Alternatives:** Manually extracting secrets from the `SSL` struct (fragile, version-dependent) or using the older `info_callback` (more complex, less reliable for this specific purpose).

**2. Implementation via Patch**
We will implement this by applying a patch to `src/event/ngx_event_openssl.c`.
*   **Rationale:** This functionality requires access to the `SSL_CTX` creation process, which happens deep in the Nginx core event module. A Lua module or external module cannot easily hook into this point before the SSL context is finalized for all connections.
*   **Alternatives:** An Nginx C module. While possible, patching the core ensures it works for all SSL contexts created by Nginx, including upstream connections if applicable, and is often simpler for enabling standard OpenSSL features not exposed by Nginx configuration.

**3. Environment Variable Control (`SSLKEYLOGFILE`)**
We will control this feature exclusively via the `SSLKEYLOGFILE` environment variable.
*   **Rationale:** This is the de-facto standard for this feature across the ecosystem (browsers, curl, Go, etc.). It avoids cluttering `nginx.conf` with debugging options and ensures it's naturally disabled by default (if the env var is unset).

## Risks / Trade-offs

**Security Risk: Traffic Decryption**
*   **Risk:** If enabled in a production environment and the log file is accessible, an attacker could decrypt all captured traffic.
*   **Mitigation:** The feature is only active if the `SSLKEYLOGFILE` environment variable is explicitly set. We will rely on standard OS file permissions for the log file. Documentation must emphasize that this is for debugging only.

**Performance Risk: Blocking I/O**
*   **Risk:** Writing to a file inside the SSL callback (which runs in the Nginx worker process) could block the event loop, degrading performance.
*   **Mitigation:** The `keylog_callback` writes small amounts of text. While technically blocking, the impact is acceptable for a debugging session. We accept this trade-off because this feature should *not* be enabled in high-load production traffic unless absolutely necessary for diagnostics.

**Compatibility Risk: OpenSSL Version**
*   **Risk:** This patch will fail to compile or work on older OpenSSL versions (< 1.1.1).
*   **Mitigation:** We will wrap the code in `#ifdef` checks for the OpenSSL version or the existence of `SSL_CTX_set_keylog_callback`.
