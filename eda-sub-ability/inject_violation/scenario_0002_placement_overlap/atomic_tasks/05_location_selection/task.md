# Task S002_05：修改位置选择

## 任务目标

根据 baseline 位置记录，为已经选定的 placement ECO 实例确定正确的恢复坐标和方向。

## 输入数据

两个相关实例在 baseline 中的位置、方向和状态：

`inputs/original_locations.tsv`

## 任务要求

选择 `_14522_` 在 baseline 中的原始 x/y 坐标和 orientation。不得选择新的空闲 site，不得移动锚点实例，也不得通过全局合法化替代明确的位置恢复。

本任务只选择修改位置，不执行 placement 或 routing 命令。

## 提交要求

将位置选择结果保存为：`answer.json`

格式如下：

```json
{
  "instance": "_14522_",
  "x_um": 0.0,
  "y_um": 0.0,
  "orient": ""
}
```

