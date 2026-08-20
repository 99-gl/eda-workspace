# Task S004_09：无效 ECO 后恢复

## 任务目标

加载 `initial_state/design.enc` 后，先执行 `inputs/bad_eco.tcl`。该 ECO 只给一个 sink 增加 buffer，因此 `_00305_` 的 real max-fanout 违例仍未关闭。

编写 `recovery.tcl`：

- 查询并删除 `BAD_FANOUT_PARTIAL_FIX`，恢复其临时分支；
- 恢复 `FE_OFC611_00305/BUF_X1`；
- 使用位置 `(14.06, 59.08)`；
- 将原 9 个 sink 全部放回 `FE_OFN611_00305` 输出分支；
- 执行必要的 legalization、routing 和 RC 提取；
- 最终关闭 real fanout、transition、capacitance、setup、hold、placement、connectivity 和 DRC；
- 不得修改约束或保存数据库。

提交 `recovery.tcl`。

