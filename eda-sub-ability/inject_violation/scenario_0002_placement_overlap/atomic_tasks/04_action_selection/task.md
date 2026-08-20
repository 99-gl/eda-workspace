# Task S002_04：ECO 动作选择

## 任务目标

根据已经确认的 placement overlap 根因、被移动实例和候选动作，选择能够以最小数据库改动恢复 routed baseline 的 ECO 动作。

## 输入数据

根因和对象诊断结果：

`inputs/diagnosis.json`

可选 ECO 动作：

`inputs/candidate_actions.json`

## 任务要求

从候选动作中选择一种，并说明作用实例和修改后的必要数据库更新。所选动作应直接消除 overlap，同时避免无关的全局 placement、cell sizing 或锚点移动。

本任务只选择 ECO 动作，不执行具体修改，不得修改设计或时序约束。

## 提交要求

将选择结果保存为：`answer.json`

格式如下：

```json
{
  "action": "",
  "instance": "",
  "post_action": ""
}
```

