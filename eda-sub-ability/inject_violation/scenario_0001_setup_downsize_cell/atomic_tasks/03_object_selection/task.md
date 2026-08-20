# Task S001_03：ECO 对象选择

## 任务目标

结合已确认的最差 Setup 路径和根因诊断结果，选择能够通过最小局部 ECO 同时修复 Setup、transition 和 capacitance 问题的完整 instance 集合。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置和物理设计数据。

最差 Setup 路径信息：

`inputs/worst_setup_path.json`

根因诊断结果：

`inputs/root_cause.json`

## 任务要求

编写 Innovus Tcl 脚本，查询目标路径上的 instance、cell、pin、输出 net、负载和 DRV，并将结果保存到：

`reports/object_analysis.rpt`

根据查询结果选择完整的 ECO instance 集合。本次只选择 ECO 对象，不执行具体修改，分析过程中不得修改设计或时序约束。

## 提交要求

提交可重放的 Innovus Tcl 脚本：

`analyze.tcl`

同时将选择结果保存为：`answer.json`

格式如下：

```json
{
  "object_type": "instance",
  "object_names": []
}
```
