# Task S004_06：修复副作用预测

## 任务目标

结合 `inputs/before_metrics.json` 与 `inputs/eco_plan.json`，预测恢复一颗 `BUF_X1` 后的结构、面积、功耗、拥塞和 timing 方向。数值标签均以本场景真实 Innovus 对比为准。

提交 `answer.json`：

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

