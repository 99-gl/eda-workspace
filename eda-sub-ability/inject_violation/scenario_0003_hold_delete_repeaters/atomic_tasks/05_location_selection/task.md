# Task S003_05：buffer 插入位置选择

## 任务目标

加载 `initial_state/design.enc`，查询 `_00140_` 的 driver 和 sinks，确定 `CLKBUF_X1` 应插入的目标分支和物理位置。

## 任务要求

提交只读查询脚本 `analyze.tcl`，将报告写到 `reports/location_analysis.rpt`，并提交：

```json
{"target_net":"","target_sinks":[],"buffer_cell":"","location_um":[0.0,0.0]}
```

本任务不得执行 ECO。
