# Task S004_09：失败恢复

## 任务目标

在一次只为单个 sink 添加 buffer、但未关闭 max-fanout 违例的无效 ECO 之后，识别临时修改并编写恢复脚本，完成正确的 fanout-tree 修复。

## 输入数据

从以下路径加载已注入 max-fanout 违例的初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置和物理设计数据。

加载初始设计后，先执行以下无效 ECO：

`inputs/bad_eco.tcl`

该 ECO 只为一个 sink 添加 `BAD_FANOUT_PARTIAL_FIX`，因此 `_00305_` 的 real max-fanout 违例仍未关闭。

## 任务要求

编写恢复脚本，并满足：

- 查询并删除 `BAD_FANOUT_PARTIAL_FIX`，恢复其临时分支；
- 恢复 `FE_OFC611_00305/BUF_X1`；
- 使用位置 `(14.06, 59.08)`；
- 将原 9 个 sink 全部恢复到 `FE_OFN611_00305` 输出分支；
- 执行必要的 legalization、增量布线和 RC 提取；
- 最终关闭 real max-fanout、transition、capacitance、Setup、Hold、placement、connectivity 和 DRC。

不得修改时序约束或保存新的设计数据库。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`recovery.tcl`
