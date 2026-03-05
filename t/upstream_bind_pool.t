use Test::Nginx::Socket 'no_plan';

run_tests();

__DATA__

=== TEST 1: basic upstream_bind_pool configuration
--- http_config
    upstream_bind_pool my_pool {
        bind 127.0.0.1;
        max_retries 1;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind_pool my_pool;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- response_body
backend reached
--- no_error_log
[error]

=== TEST 2: multiple bind IPs (parsing check)
--- http_config
    upstream_bind_pool pool_multi {
        bind 127.0.0.1;
        bind 127.0.0.1;
        max_retries 1;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind_pool pool_multi;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- response_body
backend reached
--- no_error_log
[error]

=== TEST 3: bind parameters parsing (max_fails, fail_timeout, backup)
--- http_config
    upstream_bind_pool pool_params {
        bind 127.0.0.1 max_fails=3 fail_timeout=30s;
        bind 127.0.0.1 backup;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind_pool pool_params;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- response_body
backend reached
--- no_error_log
[error]

=== TEST 4: automatic failover with invalid bind IP
# 192.0.2.1 is reserved for documentation and likely not assigned to interface.
# bind() should fail.
--- http_config
    upstream_bind_pool pool_failover {
        bind 192.0.2.1;
        bind 127.0.0.1;
        max_retries 1;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind_pool pool_failover;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- response_body
backend reached
--- error_log
bind(192.0.2.1:0) failed

=== TEST 5: max_retries 0 prevents failover
# With max_retries 0, if the first IP fails, it should error out.
# We need to ensure the bad IP is picked first. 
# Since RR index starts at 0, and we define bad IP first, it should be picked first.
--- http_config
    upstream_bind_pool pool_no_retry {
        bind 192.0.2.1;
        bind 127.0.0.1;
        max_retries 0;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind_pool pool_no_retry;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- error_code: 500
--- error_log
bind(192.0.2.1:0) failed

=== TEST 6: backup IP usage
# Primary IP is invalid. Should switch to backup immediately?
# Logic: Try primary (fail), then try backup?
# Or if max_retries is enabled, it retries.
# If max_retries is 0, does it try backup?
# Our logic: get_local_peer returns primary. If connect fails, and max_retries > 0, we call get_local_peer again.
# Next call to get_local_peer:
# RR index increments.
# If we have only 1 primary (bad) and 1 backup (good).
# First call: returns primary.
# Retry call: returns backup?
# Let's verify.
--- http_config
    upstream_bind_pool pool_backup {
        bind 192.0.2.1;
        bind 127.0.0.1 backup;
        max_retries 1;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind_pool pool_backup;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- response_body
backend reached
--- error_log
bind(192.0.2.1:0) failed

=== TEST 7: proxy_bind_pool takes precedence over proxy_bind
# proxy_bind sets an invalid IP. proxy_bind_pool sets a valid one.
# If proxy_bind_pool is used, it should succeed.
--- http_config
    upstream_bind_pool pool_valid {
        bind 127.0.0.1;
        max_retries 1;
    }
--- config
    location /t {
        proxy_pass http://127.0.0.1:$server_port/backend;
        proxy_bind 192.0.2.1;
        proxy_bind_pool pool_valid;
    }

    location /backend {
        echo "backend reached";
    }
--- request
GET /t
--- response_body
backend reached
--- no_error_log
bind(192.0.2.1:0) failed
