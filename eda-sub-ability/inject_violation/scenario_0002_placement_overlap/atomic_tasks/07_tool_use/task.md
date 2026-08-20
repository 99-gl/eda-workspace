# Task S002_07：Tcl 工具使用

## 任务目标

根据已确定的 placement repair 方案，编写可重放的 Innovus Tcl 脚本，消除标准单元 overlap 并恢复 routed baseline 的物理状态。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 placement overlap。

相关实例的 baseline 位置和角色：

`inputs/original_position.tsv`

## 任务要求

使用 Innovus placement 命令将被错误移动的实例恢复到 baseline 位置和方向，并执行必要的 RC 更新。

修复后应满足：

- overlap 消失且不存在 unplaced instance；
- 锚点实例的位置和方向保持不变；
- connectivity 和 DRC 检查通过；
- DRV 闭合；
- Setup 和 Hold slack 均非负。

不得调整时钟约束、例外路径或分析模式来掩盖问题，不得移动计划之外的实例，也不得保存新的设计数据库。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`repair.tcl`

