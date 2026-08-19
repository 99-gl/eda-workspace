# Tcl 工具使用

从 `initial_state/design.enc` 加载 routed 设计。根据 `inputs/original_position.tsv` 编写 `repair.tcl`，消除 placement overlap，并更新 RC。修复后必须保持锚点实例不动，同时闭合 placement、connectivity、DRC、DRV、setup 和 hold。只提交 `repair.tcl`，不要保存新的设计数据库。

