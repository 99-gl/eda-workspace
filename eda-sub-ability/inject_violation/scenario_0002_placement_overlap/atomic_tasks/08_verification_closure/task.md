# Task S002_08：修复闭环判断

## 任务目标

根据独立生成的修复后报告，判断当前 placement ECO 是否已经完成物理、DRV 和时序闭环。

## 输入数据

修复后的 placement、connectivity、DRC、constraint、Setup 和 Hold 报告：

`inputs/reports/`

## 任务要求

检查以下内容：

- overlap object 和 unplaced instance；
- connectivity problem；
- DRC violation；
- transition、capacitance 和其他 DRV；
- Setup WNS；
- Hold WNS。

必须依据实际报告判断是否闭环，不得只依据修复动作或工具退出状态。

## 提交要求

将判断结果保存为：`answer.json`

格式如下：

```json
{
  "closed": false,
  "overlap_objects": 0,
  "unplaced": 0,
  "connectivity_problems": 0,
  "drc": 0,
  "drv_violations": 0,
  "setup_wns_ns": 0.0,
  "hold_wns_ns": 0.0
}
```

