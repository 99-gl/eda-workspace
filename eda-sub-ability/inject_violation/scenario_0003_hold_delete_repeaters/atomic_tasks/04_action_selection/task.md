# Task S003_04：ECO 动作选择

## 任务目标

根据已选定的 ECO 对象和候选动作试验结果，选择能够以最小且稳定的局部修改闭合当前 Hold 违例的 ECO 动作。

## 输入数据

已选定的 ECO 对象：

`inputs/eco_object.json`

候选 buffer 和修复试验结果：

`inputs/candidate_trials.json`

## 任务要求

结合候选动作对 Hold、Setup 和物理实现的影响，从以下动作中选择一种：

- `size_cell`
- `swap_vt`
- `insert_buffer`
- `clone_driver`
- `adjust_placement`

所选动作应直接增加目标数据路径的最小延迟，并避免不必要的面积、功耗和物理改动。如果选择插入 buffer，应同时给出目标 buffer cell。

本任务只选择 ECO 动作，不执行具体修改，不得修改设计或时序约束。

## 提交要求

将选择结果保存为：`answer.json`

格式如下：

```json
{
  "eco_action": "",
  "buffer_cell": ""
}
```
