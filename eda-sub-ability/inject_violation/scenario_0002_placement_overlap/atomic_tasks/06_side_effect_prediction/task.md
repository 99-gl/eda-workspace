# 副作用预测

根据 `inputs/prepared_metrics.json` 和 `inputs/move_plan.json`，预测移动 routed cell 后需要关注的直接副作用。将 overlap 对象数、unplaced 数、connectivity 问题数、DRC 数，以及 setup/hold WNS 写入 `answer.json`。

