# Task S003_01：最差 Hold 路径获取

## 任务目标

在 Cadence Innovus 19.10 中加载 `initial_state/design.enc`，执行 PostRoute Hold 分析并识别最差路径。

## 任务要求

将 Hold 报告生成到 `reports/hold`，提取检查类型、Beginpoint、Endpoint、Slack、Path Group 和 Analysis View。不得修改设计或约束。

将结果保存为 `answer.json`：

```json
{"check_type":"hold","beginpoint":"","endpoint":"","slack_ns":0.0,"path_group":"","analysis_view":""}
```
