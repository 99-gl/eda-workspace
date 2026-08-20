# Task S004_02：Max-fanout 根因诊断

## 任务目标

阅读 `inputs/fanout.rpt`、`inputs/injection_metadata.tsv` 和 `inputs/candidate_trials.json`，判断主违例、违规对象以及它为什么出现。

提交 `answer.json`，格式如下：

```json
{
  "primary_violation": "...",
  "root_cause": "...",
  "merged_net": "...",
  "driver_term": "...",
  "fanout_limit": 0,
  "actual_fanout": 0,
  "transition_violations": 0,
  "capacitance_violations": 0
}
```

`root_cause` 使用简短机制标签，不要提出修复动作。

