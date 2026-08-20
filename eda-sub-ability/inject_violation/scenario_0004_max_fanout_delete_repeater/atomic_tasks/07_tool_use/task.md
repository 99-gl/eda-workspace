# Task S004_07：Innovus Tcl 修复

## 任务目标

加载 `initial_state/design.enc`，编写可重放的 Innovus Tcl 脚本，恢复被误删的 fanout-tree repeater。

## ECO 约束

- 实例名：`FE_OFC611_00305`
- cell：`BUF_X1`
- 位置：`(14.06, 59.08)`
- 输入网络：`_00305_`
- 输出网络：`FE_OFN611_00305`
- 输出侧 sink：`_19581_/D`、`_13985_/A`、`_13946_/A`、`_13929_/A1`、`_13913_/A`、`_13812_/A1`、`_13799_/A1`、`_13736_/A1`、`_13704_/A`

执行必要的 legalization、增量布线和 RC 提取。修复后 real max-fanout、transition、capacitance、setup、hold、placement、connectivity 和 DRC 必须全部闭合。不得修改约束、删除其他实例或保存数据库。

提交 `repair.tcl`。

