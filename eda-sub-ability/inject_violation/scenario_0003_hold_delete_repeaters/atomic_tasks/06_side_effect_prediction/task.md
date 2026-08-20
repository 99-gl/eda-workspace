# Task S003_06：ECO 副作用预测

## 任务目标

根据修改前指标和计划执行的 buffer ECO，预测该修改对 Hold、Setup、DRV、面积、功耗和拥塞的影响。

## 输入数据

修改前指标：

`inputs/before_metrics.json`

准备执行的 ECO 方案：

`inputs/eco_plan.json`

## 任务要求

结合当前指标和 ECO 方案，预测修改后各项指标的变化方向，并给出修改前后的 Hold WNS、Setup WNS、面积和功耗数值。

方向字段中，时序和 DRV 使用 `improve`、`degrade` 或 `unchanged`；面积、功耗和拥塞使用 `increase`、`decrease` 或 `unchanged`。

本任务只进行副作用预测，不执行具体修改。

## 提交要求

将预测结果保存为：`answer.json`

格式如下：

```json
{
  "hold_timing": "",
  "setup_timing": "",
  "drv": "",
  "area": "",
  "power": "",
  "congestion": "",
  "hold_wns_before_ns": 0.0,
  "hold_wns_after_ns": 0.0,
  "setup_wns_before_ns": 0.0,
  "setup_wns_after_ns": 0.0,
  "area_before_um2": 0.0,
  "area_after_um2": 0.0,
  "power_before_mw": 0.0,
  "power_after_mw": 0.0
}
```
