## Why

在某些高并发或需要绕过防火墙限制的场景下，单源 IP 容易成为瓶颈或单点故障。目前的 `proxy_bind` 指令只能绑定单一 IP，缺乏容错能力。如果该 IP 被上游封禁或网络不通，会导致请求失败，即使 Nginx 服务器本身有多个可用 IP。

本变更旨在引入源 IP 池（Source IP Pool）机制，允许 Nginx 在连接上游时从一组 IP 中选择，并具备故障检测和自动切换能力，从而提高出口连接的可靠性和吞吐量。

## What Changes

*   **新增配置指令**：引入 `upstream_bind_pool` 配置块，用于定义源 IP 池。
*   **支持多 IP 绑定**：在池中配置多个 IP 地址。
*   **故障切换**：当使用某个源 IP 连接失败时，自动重试池中的其他 IP。
*   **熔断机制**：支持 `max_fails` 和 `fail_timeout` 参数，暂时剔除不可用的源 IP。
*   **负载均衡**：支持源 IP 的轮询选择（默认）。
*   **限制重试**：新增 `max_retries` 参数，防止在所有 IP 上无效重试导致延迟过高。

## Capabilities

### New Capabilities
- `upstream-bind-pool`: 定义和管理源 IP 池，支持故障检测和自动切换。

### Modified Capabilities
<!-- Existing capabilities whose REQUIREMENTS are changing (not just implementation).
     Only list here if spec-level behavior changes. Each needs a delta spec file.
     Use existing spec names from openspec/specs/. Leave empty if no requirement changes. -->

## Impact

*   **Configuration**: 新增 `upstream_bind_pool` 和 `proxy_bind_pool` 指令。
*   **Core**: 修改 `ngx_http_proxy_module` 的连接建立逻辑。
*   **Performance**: 增加源 IP 选择和重试逻辑，但在正常情况下开销极小；故障时会增加连接建立延迟（取决于重试次数）。
*   **Compatibility**: 完全兼容现有的 `proxy_bind` 指令（两者互斥使用）。
