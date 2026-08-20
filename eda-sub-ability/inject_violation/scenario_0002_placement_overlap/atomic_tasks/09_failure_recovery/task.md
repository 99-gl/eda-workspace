# Task S002_09：失败恢复

## 任务目标

在一次错误 placement 修复之后，识别两个实例被交换的物理角色，并编写恢复脚本还原 routed baseline。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 placement overlap。

加载初始设计后执行以下错误修改：

`inputs/bad_eco.tcl`

该修改把锚点实例移到 mover 的原始位置。虽然表面上的 overlap 消失，但两个实例都不再处于正确的 baseline 物理状态。

## 任务要求

编写恢复脚本，并满足：

- 查询两个实例的当前坐标和方向，不得假设它们仍处于初始状态；
- 将 mover 和 anchor 分别恢复到各自的 baseline 位置和方向；
- 执行必要的 RC 更新；
- 最终闭合 placement、connectivity、DRC、DRV、Setup 和 Hold。

不得通过修改约束或删除实例来绕过恢复任务。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`recovery.tcl`

