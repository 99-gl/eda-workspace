# Task S003_02：Hold 违例根因诊断

## 任务目标

结合已确认的最差 Hold 路径、详细时序报告、注入对象信息和候选试验结果，判断造成当前 Hold 违例的主要根因、贡献因素及关键对象。

## 输入数据

最差 Hold 路径信息：

`inputs/worst_hold_path.json`

详细 Hold 时序报告：

`inputs/hold_worst.rpt`

注入对象及其原始物理状态：

`inputs/injection_metadata.tsv`

候选注入与修复试验结果：

`inputs/candidate_trials.json`

## 分析要求

结合路径中的 cell delay、net delay、transition、capacitance、fanout 和拥塞信息，从以下类型中选择主要根因：

- `cell_delay`
- `net_delay`
- `fanout`
- `transition`
- `capacitance`
- `congestion`

同时识别造成该根因的贡献因素，给出与输入报告一致的关键对象集合和简要证据。证据应说明注入前后 Hold 指标及数据路径延迟变化之间的关系。

本任务只进行根因诊断，不得修改设计或输入数据。

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
