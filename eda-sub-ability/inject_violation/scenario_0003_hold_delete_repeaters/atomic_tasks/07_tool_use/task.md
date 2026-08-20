# Task S003_07：Tcl 工具使用

## 任务目标

加载 `initial_state/design.enc`，编写可重放的 Innovus Tcl 脚本，通过单颗 delay buffer 修复 Hold 违例。

## ECO 计划

- 目标 sink：`FE_PHC963_00140/A`；
- cell：`CLKBUF_X1`；
- 位置：`(47.31, 19.88)`；
- 实例名：`HOLD_FIX_CLKBUF_00140`；
- 新 net：`HOLD_FIX_CLKBUF_00140_NET`。

执行必要的 legalization、增量布线和 RC 提取。修复后 Setup/Hold、DRV、placement、connectivity、DRC 必须全部闭合。不得修改约束、删除其他实例或保存数据库。

提交 `repair.tcl`。
