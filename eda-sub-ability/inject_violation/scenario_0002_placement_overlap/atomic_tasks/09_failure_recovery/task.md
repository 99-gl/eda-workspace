# 失败恢复

从 `initial_state/design.enc` 加载设计后，`inputs/bad_eco.tcl` 会执行一个错误的位置编辑：它消除了表面上的 overlap，却交换了两个单元的物理角色并破坏 routed 状态。编写 `recovery.tcl`，恢复两个实例的 baseline 位置和方向并更新 RC。最终必须闭合全部物理、DRV 和时序检查。只提交 `recovery.tcl`。

