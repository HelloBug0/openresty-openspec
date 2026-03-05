## Context

目前 Nginx 的 `proxy_bind` 指令只支持绑定单一的本地 IP 地址。在一些特殊的网络环境下，单源 IP 可能会因为网络策略、DDoS 攻击或运营商限制而不可用。为了提高系统的健壮性，我们需要一种机制，允许 Nginx 在发起上游连接时，从一组预定义的本地 IP 中动态选择，并在连接失败时尝试其他 IP。

## Goals / Non-Goals

**Goals:**
*   实现 `upstream_bind_pool` 配置块，管理多个源 IP。
*   实现 `proxy_bind_pool` 指令，在 location 中引用 IP 池。
*   实现基于 Round Robin 的源 IP 选择算法。
*   实现连接失败时的源 IP 自动切换机制。
*   支持 `max_fails` 和 `fail_timeout` 对源 IP 进行熔断。
*   支持 `max_retries` 限制重试次数，避免连接风暴。

**Non-Goals:**
*   不支持基于权重的负载均衡（仅 Round Robin）。
*   不支持动态添加/删除 IP（仅配置重载）。
*   不支持 UDP 协议（仅 TCP）。

## Decisions

### 1. 配置语法设计
采用 `upstream_bind_pool` + `bind` 指令的设计。
*   **Decision**: 使用 `upstream_bind_pool` 定义池，池内使用 `bind` 指令定义 IP。
*   **Rationale**: 保持与 Nginx 现有 `proxy_bind` 指令的语义一致性，避免使用 `server` 引起混淆。
*   **Alternative**: 曾考虑 `upstream_cip_pool` + `cip`，虽然语义明确，但不符合 Nginx 命名惯例。

### 2. 故障切换逻辑
采用“连接级重试优先”策略。
*   **Decision**: 在 TCP 连接建立失败（超时/拒绝）时，优先在 Bind Pool 内重试其他 IP，而不是立即切换 Upstream Backend。
*   **Rationale**: 区分网络层故障（源 IP 问题）和应用层故障（后端服务问题）。如果只是源 IP 被封，切换后端无法解决问题，且浪费了健康的后端资源。
*   **Constraint**: 必须限制重试次数 (`max_retries`)，防止 N*M 的连接风暴。

### 3. 数据结构
*   复用 `ngx_http_upstream_server_t` 结构体来存储 `bind` 配置（因为包含 `addrs`, `max_fails`, `fail_timeout` 等字段）。
*   新建 `ngx_http_upstream_bind_pool_t` 结构体来管理池。

## Risks / Trade-offs

### Risk: 连接延迟增加
*   **Risk**: 如果配置了多个无效 IP 且 `max_retries` 较大，连接建立的延迟会显著增加。
*   **Mitigation**: 默认 `max_retries` 为 1，限制重试次数。建议用户配置合理的 `connect_timeout`。

### Risk: 配置复杂性
*   **Risk**: 用户可能混淆 `upstream` (后端池) 和 `upstream_bind_pool` (源 IP 池) 的故障切换逻辑。
*   **Mitigation**: 在文档中明确说明两者的区别和交互逻辑。
