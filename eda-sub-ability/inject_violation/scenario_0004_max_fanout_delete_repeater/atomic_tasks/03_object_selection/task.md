# Task S004_03：ECO 对象选择

## 任务目标

根据真实 max-fanout 违例及原始拓扑信息，选择应通过最小局部 ECO 恢复的对象，使后续修复能够重新建立缺失的 fanout 分支。

## 输入数据

违例摘要、修复候选对象及设计约束：

`inputs/candidates.json`

## 任务要求

比较各候选对象与当前违例的关系，选择直接对应缺失 fanout 分支的修复对象。选择结果应支持恢复原始拓扑，同时避免修改仍然存在的驱动实例或通过放宽 max-fanout 约束规避违例。

本任务只选择 ECO 对象，不决定具体 ECO 命令、物理位置或 sink 分组，也不执行设计修改。

## 提交要求

将选择结果保存为：`answer.json`

格式如下：

```json
{
  "object_type": "",
  "object_name": "",
  "affected_net": "",
  "selection_reason": ""
}
```
