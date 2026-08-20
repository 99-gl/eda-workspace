# Task S002_02：Placement Overlap 根因诊断

## 任务目标

结合 placement 检查、重叠对象清单、connectivity 和 DRC 报告，判断当前物理违例的主要根因、涉及实例及直接证据。

## 输入数据

Placement 检查报告：

`inputs/placement.rpt`

重叠位置上的对象清单：

`inputs/overlap_objects.tsv`

Connectivity 报告：

`inputs/connectivity.rpt`

DRC 报告：

`inputs/drc.rpt`

## 分析要求

根据 `checkPlace` 报告的 overlap 数量和对象清单中的实例位置，判断主违例是否为 placement overlap。Connectivity 和 DRC 结果用于识别移动 routed cell 后产生的伴随物理问题，不应被误判为主根因。

给出涉及的实例集合和两项直接证据。实例名称按字典序排列。本任务只进行根因诊断，不得修改任何输入数据。

## 提交要求

将诊断结果保存为：`answer.json`

格式如下：

```json
{
  "root_cause": "",
  "instances": [],
  "evidence": []
}
```

