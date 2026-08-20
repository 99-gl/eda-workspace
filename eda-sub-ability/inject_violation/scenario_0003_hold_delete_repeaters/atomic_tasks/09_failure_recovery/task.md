# Task S003_09：失败恢复

## 任务目标

在一次把 buffer 插入错误分支的 Hold ECO 之后，识别并移除错误修改，再在正确分支完成修复与闭环。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 Hold 违例。

加载初始设计后执行以下错误修改：

`inputs/bad_eco.tcl`

该脚本把 buffer 插入无关的 `_19318_/D` 分支，因此目标 Hold 路径仍未闭合。

## 任务要求

编写恢复脚本，并满足：

- 查询 `BAD_HOLD_WRONG_BRANCH` 及其连接，不得假设错误对象仍处于脚本刚执行后的状态；
- 删除错误分支上的 buffer；
- 在 `FE_PHC963_00140/A` 正确分支、位置 `(47.31, 19.88)` 插入 `CLKBUF_X1`；
- 新实例名使用 `HOLD_FIX_CLKBUF_00140`，新 net 名使用 `HOLD_FIX_CLKBUF_00140_NET`；
- 执行必要的合法化、增量布线和 RC 提取；
- 最终闭合 Setup、Hold、DRV、placement、connectivity 和 DRC。

不得修改时序约束，不得删除无关实例，也不得保存新的设计数据库。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`recovery.tcl`
