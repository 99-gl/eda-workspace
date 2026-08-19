| 子能力 | 训练任务 | 可验证标签 |
| --- | --- | --- |
| 时序报告理解 | 找出 worst path、起终点、slack、path group | 与 STA 报告一致 |
| 根因诊断 | 判断是 cell delay、net delay、fanout、transition 还是 congestion | 路径分解与物理证据 |
| ECO 对象选择 | 从路径中选择应该修改的 instance/net | 候选修改后的收益排序 |
| ECO 动作选择 | size cell、swap Vt、插 buffer、clone driver、调整 placement | 实际增量 STA 结果 |
| 修改位置选择 | buffer 插在哪里、哪些 sinks 应该拆分 | slack/transition/cap 改善量 |
| 副作用预测 | 判断是否伤害 hold、其他 setup path、面积、功耗和拥塞 | 修改前后全局 diff |
| Tcl 工具使用 | 正确执行查询、修改、legalize、route、extract、STA | 命令执行和数据库状态 |
| 验证闭环 | 判断任务是否真正完成 | WNS/TNS、DRV、DRC、connectivity |
| 失败恢复 | 无效修改后 rollback 或更换方案 | 恢复 Golden/checkpoint |
| 停止决策 | 已满足约束时不继续优化 | 无过度 ECO、无指标退化 |