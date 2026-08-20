# Task S001_07：Tcl 工具使用

## 任务目标

根据已确定的 size-cell ECO 方案，编写可重放的 Innovus Tcl 脚本，完成 Setup 与伴随 DRV 问题的修复。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置和物理设计数据。

需要执行的 cell mapping：

- `_16419_`：`OAI21_X1` → `OAI21_X4`
- `_16425_`：`OAI221_X1` → `OAI221_X4`
- `_16427_`：`OAI21_X1` → `OAI21_X4`

## 任务要求

使用 Innovus ECO 命令完成上述 cell mapping，并在修改后执行必要的合法化、增量布线和 RC 提取。

修复后应满足：

- Setup 和 Hold slack 均非负；
- transition 和 capacitance 违例闭合；
- placement、connectivity 和 DRC 检查通过。

不得调整时钟约束、例外路径或分析模式来掩盖违例，不得修改计划之外的实例。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`repair.tcl`
