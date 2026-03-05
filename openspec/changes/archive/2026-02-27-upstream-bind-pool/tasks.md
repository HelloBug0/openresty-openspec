## 1. 配置解析与数据结构

- [x] 1.1 在 `ngx_http_upstream.h` 中定义 `ngx_http_upstream_bind_pool_t` 和相关结构体
- [x] 1.2 在 `ngx_http_proxy_module` 中实现 `upstream_bind_pool` 配置块解析逻辑
- [x] 1.3 实现 `bind` 指令解析，支持 IP、`max_fails`、`fail_timeout`、`backup` 参数
- [x] 1.4 实现 `proxy_bind_pool` 指令解析，支持在 location 中引用 bind pool
- [x] 1.5 验证配置解析正确性（编写测试用例）

## 2. 核心逻辑实现

- [x] 2.1 修改 `ngx_http_upstream_init_request`，初始化 bind pool 状态
- [x] 2.2 实现 `ngx_http_upstream_get_local_peer` 函数，支持 Round Robin 选择源 IP
- [x] 2.3 修改 `ngx_event_connect_peer` 调用逻辑，使用选定的源 IP
- [x] 2.4 实现连接失败时的重试逻辑（`ngx_http_upstream_connect`），支持 `max_retries`
- [x] 2.5 实现 `max_fails` 和 `fail_timeout` 的熔断逻辑

## 3. 测试与验证

- [x] 3.1 编写测试用例验证多 IP 轮询功能
- [x] 3.2 编写测试用例验证连接失败自动切换功能
- [x] 3.3 编写测试用例验证 `max_retries` 限制
- [x] 3.4 编写测试用例验证 `backup` IP 功能
- [x] 3.5 编写测试用例验证与 `proxy_bind` 的互斥关系
