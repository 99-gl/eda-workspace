# 子能力 09：失败恢复

任务起始状态定义为：从 `initial_state/design.enc` 加载注入后的设计，然后执行 `inputs/bad_eco.tcl`。该脚本只修复 `_16419_`，因此 setup/DRV 尚未闭合。请提交 `recovery.tcl`，在这个部分修改后的状态上完成恢复。

要求：

- 保留已正确完成的 `_16419_ -> OAI21_X4`；
- 将 `_16425_`、`_16427_` 恢复为 `OAI221_X4`、`OAI21_X4`；
- 完成合法化、增量布线、RC 提取；
- setup/hold、constraint、placement、connectivity、DRC 全部闭合；
- 脚本应明确检查当前状态，不得假设三个实例仍都是 X1。

提交文件：`recovery.tcl`。
