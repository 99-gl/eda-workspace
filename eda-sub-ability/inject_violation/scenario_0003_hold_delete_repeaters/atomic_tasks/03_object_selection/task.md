# Task S003_03：ECO 对象选择

## 任务目标

结合已确认的最差 Hold 路径和根因诊断结果，从路径中选择适合通过最小局部 delay-buffer ECO 修复的 instance 或 net。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 Hold 违例。

最差 Hold 路径信息：

`inputs/worst_hold_path.json`

根因诊断结果：

`inputs/root_cause.json`

## 任务要求

编写 Innovus Tcl 脚本，查询目标路径上的 instance、pin、net、driver、sink 及其连接关系，并将结果保存到：

`reports/object_analysis.rpt`

根据查询结果选择一个适合插入 delay buffer 的 ECO 对象。所选对象应能够直接影响目标 Hold 路径，同时避免修改无关分支。

本任务只选择 ECO 对象，不执行具体修改，分析过程中不得修改设计或时序约束。

## 提交要求

提交只读、可重放的 Innovus Tcl 脚本：

`analyze.tcl`

同时将选择结果保存为：`answer.json`

格式如下：

```json
{
  "object_type": "",
  "object_name": ""
}
```
