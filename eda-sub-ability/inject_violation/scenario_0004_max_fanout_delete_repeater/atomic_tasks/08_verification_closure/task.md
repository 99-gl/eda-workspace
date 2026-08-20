# Task S004_08：修复闭环判断

## 任务目标

根据独立生成的修复后指标，判断当前 max-fanout ECO 是否已经完成 DRV、时序和物理闭环。

## 输入数据

修复后的 fanout、DRV、时序和物理检查指标：

`inputs/repaired_metrics.json`

## 任务要求

检查以下内容：

- real max-fanout、transition 和 capacitance 违例；
- Setup 和 Hold WNS/TNS；
- placement、connectivity 和 DRC。

必须依据输入中的实际指标判断是否闭环，不得只根据修复动作推断结果。本任务不修改设计。

## 提交要求

将判断结果保存为：`answer.json`

格式如下：

```json
{
  "verdict": "",
  "remaining_primary_violations": 0,
  "timing_closed": false,
  "drv_closed": false,
  "physical_closed": false
}
```
