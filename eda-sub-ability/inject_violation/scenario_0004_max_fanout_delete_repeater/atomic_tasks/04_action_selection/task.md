# Task S004_04：ECO 动作选择

## 任务目标

`inputs/problem.json` 给出了被误删 repeater 的原始状态和当前违例。选择最小、可解释、可回滚的修复动作。

提交 `answer.json`：

```json
{
  "action": "...",
  "instance": "...",
  "master": "...",
  "preserve_constraints": true,
  "required_physical_steps": ["...", "...", "..."]
}
```

