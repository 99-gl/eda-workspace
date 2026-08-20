# Task S003_07：Tcl 工具使用

## 任务目标

根据已确定的 delay-buffer ECO 方案，编写可重放的 Innovus Tcl 脚本，修复当前 Hold 违例并完成时序、DRV 和物理闭环。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 Hold 违例。

需要执行的 ECO 方案：

- 目标 sink：`FE_PHC963_00140/A`；
- buffer cell：`CLKBUF_X1`；
- 插入位置：`(47.31, 19.88)`；
- 新实例名：`HOLD_FIX_CLKBUF_00140`；
- 新 net 名：`HOLD_FIX_CLKBUF_00140_NET`。

## 任务要求

使用 Innovus ECO 命令在指定分支插入 buffer，并执行必要的合法化、增量布线和 RC 提取。

修复后应满足：

- Setup 和 Hold slack 均非负；
- transition、capacitance 和其他 DRV 闭合；
- placement、connectivity 和 DRC 检查通过。

不得调整时钟约束、例外路径或分析模式来掩盖违例，不得删除或修改计划之外的实例，也不得保存新的设计数据库。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`repair.tcl`
