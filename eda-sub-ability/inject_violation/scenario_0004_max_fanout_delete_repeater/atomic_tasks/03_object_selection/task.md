# Task S004_03：ECO 对象选择

## 任务目标

根据 `inputs/candidates.json`，选择能制造单一 real max-fanout 违例、同时不引入 transition 或 capacitance 违例的 repeater。不能通过放宽约束来规避违例。

提交 `answer.json`：

```json
{
  "selected_instance": "...",
  "selected_input_net": "...",
  "selected_output_net": "...",
  "rejected_instances": ["...", "..."],
  "selection_reason": "..."
}
```

