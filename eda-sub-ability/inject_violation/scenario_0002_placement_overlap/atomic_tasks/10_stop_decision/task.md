# Task S002_10：停止决策

## 任务目标

根据已经修复的设计指标，判断当前 placement ECO 流程应该停止还是继续。

## 输入数据

修复后的汇总指标和实例状态：

`inputs/repaired_metrics.json`

## 任务要求

重新检查以下验收条件：

- overlap 和 unplaced 是否归零；
- connectivity、DRC 和 DRV 是否闭合；
- Setup 和 Hold 是否闭合；
- mover 是否回到原始位置；
- anchor 是否保持不变；
- 是否仍有必要执行额外 placement、legalization 或 routing。

根据检查结果决定 `stop` 或 `continue`。本任务不得修改设计，也不得提交修复脚本。

## 提交要求

将决策保存为：`answer.json`

格式如下：

```json
{
  "decision": "",
  "additional_placement_edits": false,
  "additional_legalization": false,
  "additional_routing": false
}
```
