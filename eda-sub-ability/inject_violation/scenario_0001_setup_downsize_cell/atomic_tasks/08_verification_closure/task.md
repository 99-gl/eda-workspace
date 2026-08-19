# Task S001_08：修复闭环判断

根据独立生成的 setup、hold、constraint、DRC、connectivity 和 placement 结果，判断修复是否通过。提交 `answer.json`，不得只依据修复脚本的退出码。

```json
{
  "status": "PASS",
  "setup_wns_ns": 0.0,
  "setup_tns_ns": 0.0,
  "hold_wns_ns": 0.0,
  "hold_tns_ns": 0.0,
  "drv_clean": true,
  "drc_clean": true,
  "connectivity_clean": true,
  "placement_clean": true
}
```
