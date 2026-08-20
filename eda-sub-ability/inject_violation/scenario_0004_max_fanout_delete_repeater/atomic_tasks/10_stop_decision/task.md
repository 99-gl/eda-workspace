# Task S004_10：停止决策

## 任务目标

根据已经修复的设计指标，判断当前 max-fanout ECO 流程应该停止还是继续，并避免在约束已经满足后实施过度优化。

## 输入数据

修复后的最终状态和已执行 ECO 数量：

`inputs/final_state.json`

## 任务要求

重新检查以下验收条件：

- real max-fanout、transition 和 capacitance 是否闭合；
- Setup 和 Hold 是否闭合；
- placement、connectivity 和 DRC 是否通过；
- 是否仍有必要增加 buffer、upsize driver 或修改其他设计对象。

在全部条件满足时应停止，不得通过放宽约束或继续添加无必要的 ECO 来改变已经闭合的设计。本任务不修改设计，也不提交修复脚本。

## 提交要求

将决策保存为：`answer.json`

格式如下：

```json
{
  "stop": false,
  "reason": "",
  "additional_eco": ""
}
```
