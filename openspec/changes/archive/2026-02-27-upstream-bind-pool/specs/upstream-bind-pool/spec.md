## ADDED Requirements

### Requirement: upstream_bind_pool 配置指令
系统 SHALL 支持定义名为 `upstream_bind_pool` 的配置块，用于管理一组源 IP 地址。

#### Scenario: 定义简单的 bind pool
- **WHEN** 在 `http` 上下文中配置 `upstream_bind_pool my_pool { ... }`
- **THEN** 系统解析该配置并创建一个名为 `my_pool` 的源 IP 池

#### Scenario: 配置 bind 指令
- **WHEN** 在 `upstream_bind_pool` 中使用 `bind 192.168.1.10;` 指令
- **THEN** 该 IP 地址被添加到池中，未配置 max_fails 和 fail_timeout 时，max_fails 默认取值为 1，fail_timeout 默认取值为 10s

#### Scenario: 配置 max_fails 和 fail_timeout
- **WHEN** 配置 `bind 192.168.1.10 max_fails=3 fail_timeout=30s;`
- **THEN** 当该 IP 连接失败达到 3 次时，在 30 秒内不再使用该 IP

#### Scenario: 配置 backup 参数
- **WHEN** 配置 `bind 192.168.1.12 backup;`
- **THEN** 只有当非 backup 的 IP 都不可用时，才使用该 IP

### Requirement: proxy_bind_pool 配置指令
系统 SHALL 支持在 `location` 或 `server` 上下文中引用已定义的 `upstream_bind_pool`。

#### Scenario: 引用 bind pool
- **WHEN** 在 location 中配置 `proxy_bind_pool my_pool;`
- **THEN** 对该 location 的请求将从 `my_pool` 中选择源 IP 发起连接

### Requirement: 源 IP 选择与故障切换
系统 SHALL 在连接上游时从 bind pool 中选择一个可用的 IP，并在连接失败时尝试其他 IP。

#### Scenario: 默认轮询选择
- **WHEN** `upstream_bind_pool` 中没有配置特定的负载均衡算法
- **THEN** 系统按轮询方式（Round Robin）选择源 IP

#### Scenario: 连接失败自动重试
- **WHEN** 使用选定的 IP 连接上游超时或被拒绝，且 `max_retries` 未达到上限
- **THEN** 系统自动选择下一个可用的 IP 并重试连接

#### Scenario: 达到 max_retries 上限
- **WHEN** 重试次数达到 `max_retries` 限制（默认 1 次）
- **THEN** 系统放弃当前连接尝试，向上层报告错误（触发 `proxy_next_upstream`）

### Requirement: max_retries 参数
系统 SHALL 支持在 `upstream_bind_pool` 中配置 `max_retries` 参数，限制最大重试次数。

#### Scenario: 配置自定义 max_retries
- **WHEN** 配置 `max_retries 2;`
- **THEN** 系统允许在初始尝试失败后，最多重试 2 次其他 IP

#### Scenario: 默认 max_retries
- **WHEN** 未显式配置 `max_retries`
- **THEN** 系统默认 `max_retries` 为 1
