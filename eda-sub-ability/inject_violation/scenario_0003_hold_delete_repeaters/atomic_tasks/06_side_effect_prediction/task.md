# Task S003_06：ECO 副作用预测

## 任务目标

根据 `inputs/before_metrics.json` 和 `inputs/eco_plan.json`，预测插入一颗 `CLKBUF_X1` 对 Hold、Setup、DRV、面积、功耗和拥塞的影响。

## 提交要求

本任务只分析，不执行修改。提交：

```json
{
  "hold_timing":"","setup_timing":"","drv":"","area":"","power":"","congestion":"",
  "hold_wns_before_ns":0.0,"hold_wns_after_ns":0.0,"setup_wns_before_ns":0.0,"setup_wns_after_ns":0.0,
  "area_before_um2":0.0,"area_after_um2":0.0,"power_before_mw":0.0,"power_after_mw":0.0
}
```

Timing/DRV 字段使用 `improve`、`degrade` 或 `unchanged`；其他方向字段使用 `increase`、`decrease` 或 `unchanged`。
