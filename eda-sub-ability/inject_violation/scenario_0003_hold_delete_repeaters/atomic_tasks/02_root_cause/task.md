# Task S003_02：Hold 违例根因诊断

## 任务目标

结合 `inputs/worst_hold_path.json`、`inputs/hold_worst.rpt`、注入对象元数据和候选试验，判断当前 Hold 违例的物理根因。

## 任务要求

从 `cell_delay`、`net_delay`、`fanout`、`transition`、`capacitance`、`congestion` 中选择主要根因，并给出贡献因素、关键对象和报告证据。不得修改设计。

提交 `answer.json`：

```json
{"root_cause":"","contributing_factor":"","primary_objects":[],"evidence":""}
```
