<!-- Use this as the structure for your output file. Fill in the sections. -->
## 1. Analysis & Preparation

- [x] 1.1 Locate `ngx_event_openssl.c` in the OpenResty/Nginx source tree.
- [x] 1.2 Verify OpenSSL version compatibility (check for `SSL_CTX_set_keylog_callback`).
- [x] 1.3 Create a reproduction test case (or manual test plan) to verify current behavior (no keylog).

## 2. Implementation

- [x] 2.1 Create the patch file for `src/event/ngx_event_openssl.c`.
- [x] 2.2 Implement `ngx_ssl_keylog_callback` function to write secrets to the file.
- [x] 2.3 Modify `ngx_event_openssl.c` to read `SSLKEYLOGFILE` env var.
- [x] 2.4 Register the callback using `SSL_CTX_set_keylog_callback` if env var is set.
- [x] 2.5 Ensure file opening handles errors gracefully (log to error log).

## 3. Verification

- [ ] 3.1 Build OpenResty with the patch applied.
- [ ] 3.2 Run Nginx with `SSLKEYLOGFILE` set and verify the file is created and populated.
- [ ] 3.3 Verify Nginx behavior when `SSLKEYLOGFILE` is NOT set (no file created).
- [ ] 3.4 Verify Nginx behavior when `SSLKEYLOGFILE` points to an invalid path (error logged, Nginx starts).
- [ ] 3.5 Use Wireshark or `tshark` to decrypt captured traffic using the generated key log.
