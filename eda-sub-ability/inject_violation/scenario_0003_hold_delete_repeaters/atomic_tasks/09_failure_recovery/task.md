# Task S003_09：失败恢复

## 任务目标

加载 `initial_state/design.enc` 后，先执行 `inputs/bad_eco.tcl`。该脚本把 buffer 插到了无关的 `_19318_/D` 分支，因此目标 Hold 路径仍未闭合。

## 任务要求

编写 `recovery.tcl`：

- 查询 `BAD_HOLD_WRONG_BRANCH` 及其连接，不得假设错误对象仍处于脚本刚执行后的状态；
- 删除错误分支上的 buffer；
- 在 `FE_PHC963_00140/A` 正确分支、位置 `(47.31, 19.88)` 插入 `CLKBUF_X1`，实例名使用 `HOLD_FIX_CLKBUF_00140`，新 net 使用 `HOLD_FIX_CLKBUF_00140_NET`；
- 执行必要的 legalization、routing 和 RC 提取；
- 最终闭合 Setup、Hold、DRV、placement、connectivity 和 DRC；
- 不得修改时序约束或保存数据库。

提交 `recovery.tcl`。
