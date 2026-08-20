# Task S003_01：最差 Hold 路径获取

## 任务目标

基于 Cadence Innovus 19.10 对当前提供的初始设计执行 Hold 时序分析，并识别最差 Hold 路径。

## 输入数据

从以下路径加载初始设计：

`initial_state/design.enc`

该 checkpoint 是自包含的，其中包括 MMMC 时序配置、物理设计数据和已注入的 Hold 违例。

## 任务要求

对当前设计执行 PostRoute Hold 时序分析，并将报告生成到：

`reports/hold`

从生成的报告中提取最差路径的：

- 检查类型；
- Beginpoint；
- Endpoint；
- Slack，单位为 ns；
- Path Group；
- Analysis View。

分析过程中不得修改设计或时序约束。

## 提交要求

将分析结果保存为：`answer.json`

格式如下：

```json
{
  "check_type": "hold",
  "beginpoint": "",
  "endpoint": "",
  "slack_ns": 0.0,
  "path_group": "",
  "analysis_view": ""
}
```
