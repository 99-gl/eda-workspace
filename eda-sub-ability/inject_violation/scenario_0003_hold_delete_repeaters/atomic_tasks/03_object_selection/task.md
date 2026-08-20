# Task S003_03：ECO 对象选择

## 任务目标

加载 `initial_state/design.enc`，结合已确认的最差 Hold 路径和根因，从路径中选择一个适合局部 delay-buffer ECO 的 instance 或 net。

## 任务要求

提交查询路径连接关系的 `analyze.tcl`，报告写到 `reports/object_analysis.rpt`；不得修改数据库。将选择保存为：

```json
{"object_type":"","object_name":""}
```
