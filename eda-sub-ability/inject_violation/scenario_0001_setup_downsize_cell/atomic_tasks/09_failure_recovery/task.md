# Task S001_09：失败恢复

## 任务目标

在一次只完成部分 cell-sizing 修复的状态上，识别已经完成和仍未完成的动作，并编写恢复脚本完成剩余 ECO 与闭环。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置和物理设计数据。

加载初始设计后执行以下部分修复脚本：

`inputs/bad_eco.tcl`

该脚本只完成 `_16419_` 到 `OAI21_X4` 的修改，Setup 和 DRV 尚未闭合。

## 任务要求

编写恢复脚本，并满足：

- 保留已经正确完成的 `_16419_` 修改；
- 完成 `_16425_` 和 `_16427_` 尚未执行的 cell sizing；
- 检查实例当前状态，不得假设三个实例仍然全部为 X1；
- 完成必要的合法化、增量布线和 RC 提取；
- 最终闭合 Setup、Hold、DRV、placement、connectivity 和 DRC。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`recovery.tcl`
