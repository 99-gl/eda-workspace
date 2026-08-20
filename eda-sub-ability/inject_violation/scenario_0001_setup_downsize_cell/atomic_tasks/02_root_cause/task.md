# Task S001_02：Setup 违例根因诊断

## 任务目标

结合已确认的最差 Setup 路径、详细时序报告和 PostRoute DRV 结果，判断造成当前 Setup 违例的主要根因、贡献因素及关键对象。

## 输入数据

最差 Setup 路径信息：

`inputs/worst_setup_path.json`

详细 Setup 时序报告：

`inputs/setup_worst.rpt`

DRV 摘要：

`inputs/drv_violations.json`

详细 constraint 报告：

`inputs/drv_constraints.rpt`

## 分析要求

结合路径中的 cell delay、net delay、transition、capacitance、fanout 和拥塞信息，从以下类型中选择主要根因和贡献因素：

- `cell_delay`
- `net_delay`
- `fanout`
- `transition`
- `capacitance`
- `congestion`

同时给出与报告一致的关键实例集合和简要证据。本任务只进行根因诊断，不得修改设计。

## 提交要求

将诊断结果保存为：`answer.json`

格式如下：

```json
{
  "root_cause": "",
  "contributing_factor": "",
  "primary_objects": [],
  "evidence": ""
}
```
