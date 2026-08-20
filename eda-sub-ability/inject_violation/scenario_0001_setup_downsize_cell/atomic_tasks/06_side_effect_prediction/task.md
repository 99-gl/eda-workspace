# Task S001_06：ECO 副作用预测

## 任务目标

根据已经确定的 size-cell ECO 方案，预测该修改对 Setup、Hold、DRV、面积、功耗和拥塞的影响。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置和物理设计数据。

修改前指标：

`inputs/before_metrics.json`

准备执行的 ECO 方案：

`inputs/eco_plan.json`

## 任务要求

结合当前设计和 ECO 方案，预测修改后各项指标的变化方向，并给出修改前后的 Setup WNS、Hold WNS、面积和功耗数值。本次只进行副作用预测，不执行具体修改。

方向字段中，时序和 DRV 使用 `improve`、`degrade` 或 `unchanged`；面积、功耗和拥塞使用 `increase`、`decrease` 或 `unchanged`。

## 提交要求

将预测结果保存为：`answer.json`

格式如下：

```json
{
  "setup_timing": "",
  "hold_timing": "",
  "drv": "",
  "area": "",
  "power": "",
  "congestion": "",
  "setup_wns_before_ns": 0.0,
  "setup_wns_after_ns": 0.0,
  "hold_wns_before_ns": 0.0,
  "hold_wns_after_ns": 0.0,
  "area_before_um2": 0.0,
  "area_after_um2": 0.0,
  "power_before_mw": 0.0,
  "power_after_mw": 0.0
}
```
