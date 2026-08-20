# Task S001_04：ECO 动作选择

## 任务目标

根据已经选定的 ECO 对象和候选动作试验结果，选择能够修复当前 Setup 与伴随 DRV 问题的最小 ECO 动作。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置和物理设计数据。

已选定的 ECO 对象：

`inputs/eco_objects.json`

候选动作试验结果：

`inputs/candidate_trials.json`

## 任务要求

结合候选动作的增量 STA、DRV 和物理影响，从以下动作中选择一种：

- `size_cell`
- `swap_vt`
- `insert_buffer`
- `clone_driver`
- `adjust_placement`

如果所选动作需要指定目标 cell，应同时给出每个实例对应的 cell mapping。本次只选择 ECO 动作，不执行具体修改，不得修改设计或时序约束。

## 提交要求

将选择结果保存为：`answer.json`

格式如下：

```json
{
  "eco_action": "",
  "cell_mapping": {}
}
```
