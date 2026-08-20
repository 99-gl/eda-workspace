# Task S004_07：Tcl 工具使用

## 任务目标

根据已经确定的 repeater 修复方案，编写可重放的 Innovus Tcl 脚本，恢复被误删的 fanout-tree repeater 并完成物理闭环。

## 输入数据

从以下路径加载已注入 max-fanout 违例的初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已合并的违规网络。

## 任务要求

恢复以下原始 fanout 分支：

- 实例名：`FE_OFC611_00305`
- cell：`BUF_X1`
- 位置：`(14.06, 59.08)`
- 输入网络：`_00305_`
- 输出网络：`FE_OFN611_00305`
- 输出侧 sink：`_19581_/D`、`_13985_/A`、`_13946_/A`、`_13929_/A1`、`_13913_/A`、`_13812_/A1`、`_13799_/A1`、`_13736_/A1`、`_13704_/A`

使用 Innovus ECO 命令恢复 repeater 和输出分支，并执行必要的 legalization、增量布线和 RC 提取。修复后应满足：

- real max-fanout、transition 和 capacitance 违例关闭；
- Setup 和 Hold slack 均非负；
- placement、connectivity 和 DRC 检查通过。

不得修改时序约束、删除其他实例或保存新的设计数据库。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`repair.tcl`
