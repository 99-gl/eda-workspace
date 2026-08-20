# Task S002_03：ECO 对象选择

## 任务目标

结合两个重叠实例的原始位置和当前位置，选择应通过最小局部 ECO 恢复的实例，并识别不应移动的锚点实例。

## 输入数据

Baseline 中的原始位置：

`inputs/original_locations.tsv`

注入后的重叠位置：

`inputs/current_overlap.tsv`

## 任务要求

比较两个实例在 baseline 和注入状态中的坐标与方向，判断哪个实例偏离了原始位置。选择需要恢复的 instance，同时给出应保持不动的 anchor instance 和选择理由。

目标是用最少的 placement 修改恢复原始物理状态。本任务只选择 ECO 对象，不执行具体修改。

## 提交要求

将选择结果保存为：`answer.json`

格式如下：

```json
{
  "selected_instance": "",
  "do_not_move": "",
  "reason": ""
}
```

