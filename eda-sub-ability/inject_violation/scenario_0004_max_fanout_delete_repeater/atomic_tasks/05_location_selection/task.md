# Task S004_05：修复位置与 sink 分组

## 任务目标

根据 `inputs/topology.json`，确定恢复 repeater 的位置、输出网络名和必须重新分离到输出侧的 sink 集合。提交的 sink 顺序必须与输入中的原分支顺序一致。

提交 `answer.json`：

```json
{
  "location": [0.0, 0.0],
  "output_net": "...",
  "sink_terms": ["..."],
  "sink_count": 0
}
```

