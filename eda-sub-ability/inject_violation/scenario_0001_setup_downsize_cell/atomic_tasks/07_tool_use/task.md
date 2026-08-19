# 子能力 07：Tcl/工具正确使用

从 `initial_state/design.enc` 加载注入后的设计，编写 `repair.tcl` 完成 setup ECO。

要求：

- 仅修改 `_16419_`、`_16425_`、`_16427_`，分别恢复为 `OAI21_X4`、`OAI221_X4`、`OAI21_X4`；
- 使用 Innovus ECO 命令，并在修改后完成合法化、增量布线和 RC 提取；
- setup/hold slack 均非负，所有 constraint、placement、connectivity、DRC 检查通过；
- 不得调整时钟约束、例外路径或分析模式来掩盖违例。

提交文件：`repair.tcl`。
