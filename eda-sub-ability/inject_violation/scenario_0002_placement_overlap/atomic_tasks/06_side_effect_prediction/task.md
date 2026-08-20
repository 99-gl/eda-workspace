# Task S002_06：Placement 修改副作用预测

## 任务目标

根据 baseline 指标和计划执行的 routed-cell 移动，预测该修改对 placement、connectivity、DRC、Setup 和 Hold 的直接影响。

## 输入数据

修改前指标：

`inputs/prepared_metrics.json`

计划执行的移动：

`inputs/move_plan.json`

## 任务要求

预测移动后 overlap object、unplaced instance、connectivity problem 和 DRC violation 的数量，并给出修改后的 Setup WNS 与 Hold WNS。

需要区分主目标违例和伴随副作用：目标是 placement overlap；routed cell 的 pin 离开原有布线后，还可能出现 open、dangling wire 或 short。本任务只进行副作用预测，不执行具体修改。

## 提交要求

将预测结果保存为：`answer.json`

格式如下：

```json
{
  "overlap_objects": 0,
  "unplaced": 0,
  "connectivity_problems": 0,
  "drc": 0,
  "setup_wns_ns": 0.0,
  "hold_wns_ns": 0.0
}
```

