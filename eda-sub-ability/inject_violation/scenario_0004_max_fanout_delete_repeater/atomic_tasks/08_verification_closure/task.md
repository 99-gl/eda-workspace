# Task S004_08：验证闭环判断

## 任务目标

阅读 `inputs/repaired_metrics.json`，判断修复是否同时关闭 max-fanout、transition、capacitance、timing、placement、connectivity 和 DRC。

提交 `answer.json`：

```json
{
  "verdict": "...",
  "remaining_primary_violations": 0,
  "timing_closed": true,
  "drv_closed": true,
  "physical_closed": true
}
```

