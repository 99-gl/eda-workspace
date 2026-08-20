# Task S004_05：修改位置选择

## 任务目标

根据原始 fanout-tree 拓扑，为已经选定的 repeater 修复确定物理位置、输出网络名和输出侧 sink 分组。

## 输入数据

Repeater 的原始位置、输入/输出网络和原始 sink 分支：

`inputs/topology.json`

## 任务要求

选择原始 repeater 位置和原始输出网络，并给出需要从当前合并网络重新分离到输出侧的完整 sink 集合。`sink_terms` 的顺序应与输入中的原始分支顺序一致，`sink_count` 应与提交的集合大小一致。

本任务只选择修改位置与分支对象，不执行 placement、routing 或其他数据库修改。

## 提交要求

将位置与分组结果保存为：`answer.json`

格式如下：

```json
{
  "location": [0.0, 0.0],
  "output_net": "",
  "sink_terms": [],
  "sink_count": 0
}
```
