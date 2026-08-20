# Task S003_08：修复闭环判断

## 任务目标

根据独立生成的修复后报告和指标，判断当前 Hold ECO 是否已经完成时序、DRV 和物理闭环。

## 输入数据

修复后的汇总指标：

`inputs/repaired_metrics.json`

修复后的 Setup、Hold、constraint、placement、connectivity 和 DRC 报告：

`inputs/reports/`

## 任务要求

检查以下内容：

- Setup WNS/TNS；
- Hold WNS/TNS；
- transition、capacitance 和其他 DRV；
- placement；
- connectivity；
- DRC。

必须依据实际报告判断是否闭环，不得只依据 ECO 动作、修复脚本输出或工具退出状态。

## 提交要求

将判断结果保存为：`answer.json`

格式如下：

```json
{
  "status": "",
  "setup_wns_ns": 0.0,
  "setup_tns_ns": 0.0,
  "hold_wns_ns": 0.0,
  "hold_tns_ns": 0.0,
  "drv_clean": false,
  "drc_clean": false,
  "connectivity_clean": false,
  "placement_clean": false
}
```
