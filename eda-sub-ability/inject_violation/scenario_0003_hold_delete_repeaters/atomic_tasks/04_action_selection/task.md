# Task S003_04：ECO 动作选择

## 任务目标

根据目标 net 和实际候选试验，在 `size_cell`、`swap_vt`、`insert_buffer`、`clone_driver`、`adjust_placement` 中选择最小且稳定闭合 Hold 的动作。

## 输入

- `inputs/eco_object.json`
- `inputs/candidate_trials.json`

本任务只选择动作，不修改设计。提交：

```json
{"eco_action":"","buffer_cell":""}
```
