# Task S003_05：Buffer 插入位置选择

## 任务目标

根据已选定的 ECO net 和 buffer 动作，确定应插入 buffer 的目标 sink 分支和物理位置。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 Hold 违例。

已选定的 ECO 对象：

`inputs/eco_object.json`

已选定的 ECO 动作：

`inputs/eco_action.json`

## 任务要求

编写 Innovus Tcl 脚本，查询目标 net 的 driver、sinks、分支连接关系以及相关实例的物理位置，并将结果保存到：

`reports/location_analysis.rpt`

选择能够增加目标 Hold 路径最小延迟、且不影响无关 sink 的目标分支。插入位置应位于可合法化的标准单元区域，并尽量减少额外绕线。

本任务只选择目标分支和位置，不执行 ECO、placement 或 routing 修改。

## 提交要求

提交只读、可重放的 Innovus Tcl 脚本：

`analyze.tcl`

同时将位置选择结果保存为：`answer.json`

格式如下：

```json
{
  "target_net": "",
  "target_sinks": [],
  "buffer_cell": "",
  "location_um": [0.0, 0.0]
}
```
