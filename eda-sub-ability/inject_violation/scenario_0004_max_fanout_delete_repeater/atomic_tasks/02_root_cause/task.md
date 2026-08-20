# Task S004_02：Max-fanout 违例根因诊断

## 任务目标

结合 fanout 报告和注入对象记录，判断当前真实 max-fanout 违例的物理根因、违规网络及其驱动端，并区分主违例与伴随 DRV。

## 输入数据

Max-fanout 报告：

`inputs/fanout.rpt`

注入对象及拓扑变化记录：

`inputs/injection_metadata.tsv`

## 分析要求

根据报告中的 `Remark` 区分真实数据网络违例与时钟网络提示，提取真实违规网络的 fanout limit、actual fanout 和 driver term。结合拓扑记录说明 repeater 删除如何使上下游网络合并，并核对是否同时出现 transition 或 capacitance 违例。

本任务只进行根因诊断，不选择或执行修复动作，也不得修改任何输入数据。

## 提交要求

将诊断结果保存为：`answer.json`

格式如下：

```json
{
  "primary_violation": "",
  "root_cause": "",
  "merged_net": "",
  "driver_term": "",
  "fanout_limit": 0,
  "actual_fanout": 0,
  "transition_violations": 0,
  "capacitance_violations": 0
}
```

`root_cause` 使用简短的机制标签，不要在该字段中提出修复动作。
