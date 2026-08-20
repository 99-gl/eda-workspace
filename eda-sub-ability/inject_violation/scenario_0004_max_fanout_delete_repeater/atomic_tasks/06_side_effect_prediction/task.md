# Task S004_06：ECO 副作用预测

## 任务目标

根据修改前指标和计划执行的 repeater 恢复 ECO，预测该修复对结构、面积、功耗、拥塞、Setup、Hold 和 real max-fanout 的影响。

## 输入数据

修改前指标：

`inputs/before_metrics.json`

准备执行的 ECO 方案：

`inputs/eco_plan.json`

## 任务要求

给出新增 cell 数量以及面积、功耗、拥塞 overflow、Setup WNS 和 Hold WNS 的变化量，并预测修复后的 real max-fanout 违例数。数值以本场景真实 Innovus 修改前后对比为准，变化量统一按“修复后减修复前”计算。

本任务只进行副作用预测，不执行具体修改。

## 提交要求

将预测结果保存为：`answer.json`

格式如下：

```json
{
  "cell_delta": 0,
  "area_delta_um2": 0.0,
  "power_delta_mw": 0.0,
  "congestion_overflow_delta": 0,
  "setup_wns_change_ns": 0.0,
  "hold_wns_change_ns": 0.0,
  "real_fanout_after": 0
}
```
