# Task S004_04：ECO 动作选择

## 任务目标

根据已经确认的 max-fanout 根因和修复对象，选择能够以最小、可解释、可回滚方式恢复原始 fanout 分支的 ECO 动作。

## 输入数据

被删除 repeater 的原始状态、当前违例及约束要求：

`inputs/problem.json`

## 任务要求

在恢复被删除 repeater、upsize driver、clone driver 或放宽约束等可能动作中，选择能够直接逆转根因且数据库改动最小的方案。说明作用实例、目标 cell，以及修改后必须执行的物理更新步骤。

不得通过修改 max-fanout 或其他时序约束来掩盖违例。本任务只选择 ECO 动作，不执行具体修改。

## 提交要求

将选择结果保存为：`answer.json`

格式如下：

```json
{
  "action": "",
  "instance": "",
  "master": "",
  "preserve_constraints": true,
  "required_physical_steps": []
}
```
