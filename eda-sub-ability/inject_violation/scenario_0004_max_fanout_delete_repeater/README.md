# max_fanout_delete_repeater 场景说明

## 场景目标

本场景在 `aes_cipher_top` 的 Nangate45 routed baseline 上构造一个可保存、可 fresh-load、可精确修复的 **real max-fanout** 违例。正式验证使用 Cadence Innovus `19.10-p002_1`。

这里的“real”很重要：baseline 的 `reportFanoutViolation` 会列出 17 条时钟网络记录，remark 为 `C`，并明确写明 `0 violation is real (remark R)`。本场景的主指标只统计 remark `R`，不会把 baseline 已知的 clock-only 项误报成新违例。

## Baseline 审计

正式注入从 `../../baseline/aes_route.enc(.dat)` fresh-load。注入前实测结果为：

- setup WNS/TNS：`+0.390 / 0 ns`
- hold WNS/TNS：`+0.026 / 0 ns`
- real max-fanout：`0`
- max-transition / max-capacitance：`0 / 0`
- placement overlap：`0`，`Unplaced = 0`
- connectivity：无 problem 或 warning
- DRC：`0`

对应证据位于 `reports/prepared/`。当前 Nangate45 LEF 不含 process antenna rule，antenna 检查记为 `N/A`，不声称为零违例。

## 候选试验

先从 untouched baseline 枚举删除后 fanout 会超过约束 16 的数据 repeater，共得到 457 个候选，其中 21 个最小程度超限到 17。选取三种分支形态独立试验：

| 候选 | 删除实例 | 合并形态 | real fanout | 其他 DRV | 结果 |
| --- | --- | ---: | ---: | --- | --- |
| A | `FE_OFC568_09155` | `2+16-1=17` | 1 | `_09155_` 同时出现 max-cap：`0.035 > 0.025` | 淘汰 |
| B | `FE_OFC611_00305` | `9+9-1=17` | 1 | transition=0，cap=0 | 采用 |
| C | `FE_OFC702_01816` | `5+13-1=17` | 1 | `_01816_` 同时出现 max-cap：`0.036 > 0.025` | 淘汰 |

候选 B 的注入与修复 checkpoint 都通过了独立 fresh-load；完整证据与失败原因位于 `reports/candidate_trials/`。

## 正式注入

原始 repeater 状态为：

| 属性 | 值 |
| --- | --- |
| instance | `FE_OFC611_00305` |
| master | `BUF_X1` |
| location / orientation | `(14.06, 59.08) / R0` |
| input net | `_00305_` |
| output net | `FE_OFN611_00305` |
| upstream driver | `_13365_/ZN`，`INV_X1` |
| upstream loads / output loads | `9 / 9` |

`perturb.tcl` 使用 `ecoDeleteRepeater` 删除该实例，再执行 `ecoRoute` 和 `extractRC`。删除后原输出分支的 9 个 sink 合并回 `_00305_`；上游 driver 的 fanout 变为 `9 - 1 + 9 = 17`，超过约束 16。

Innovus 的对象证明为：

- `FE_OFC611_00305` 在数据库中不存在；
- `_00305_` 的实际 load 数为 17；
- `reportFanoutViolation` 指向 `_00305_` 与 `_13365_/ZN`，remark 为 `R`；
- 整个设计恰好增加 1 个 real fanout 违例。

注入后 setup/hold WNS 仍为 `+0.390/+0.026 ns`，transition、capacitance、placement、connectivity 和 DRC 均干净。注入 checkpoint 为：

```text
outputs/max_fanout_delete_repeater.enc
outputs/max_fanout_delete_repeater.enc.dat/
```

初学者可以把根因理解为：原来的 buffer 把一大组接收端隔离在第二段网络上；buffer 被删后，两段网络合并，上一级门直接承担 17 个接收端，超过允许的 16 个。

## Golden repair

`golden_repair.tcl` 使用相同实例名、`BUF_X1`、原位置和原输出网络，重新把以下 9 个 sink 分到 buffer 输出侧：

```text
_19581_/D  _13985_/A  _13946_/A  _13929_/A1  _13913_/A
_13812_/A1 _13799_/A1 _13736_/A1 _13704_/A
```

随后执行 `refinePlace`、`ecoRoute` 和 `extractRC`。修复后的数据库确认实例恢复到 `(14.06,59.08) R0`，real fanout 归零，setup/hold、全部 DRV、placement、connectivity 和 DRC 均闭合。修复 checkpoint 为：

```text
outputs/golden_repaired.enc
outputs/golden_repaired.enc.dat/
```

## 副作用

| 指标 | 注入 | 修复 | 差值 |
| --- | ---: | ---: | ---: |
| cells | 11772 | 11773 | +1 |
| area | 15056.1 µm² | 15056.9 µm² | +0.8 µm² |
| total power | 19.23741035 mW | 19.23749863 mW | +0.00008828 mW |
| congestion overflow | 1 | 1 | 0 |
| setup WNS | +0.390 ns | +0.390 ns | 0 |
| hold WNS | +0.026 ns | +0.026 ns | 0 |

完整报告位于 `reports/side_effects/`。

## 可复现性与失败恢复

正式流程从两个互不复用的 untouched baseline 副本独立运行。两次都得到相同对象、fanout 17、1 个 real fanout 违例、相同 setup/hold WNS，以及修复后的 real fanout 0。两个正式 checkpoint 都在独立 Innovus 进程中 fresh-load 并重新执行报告与数据库断言。第二次运行证据在 `reports/reproducibility_run/` 和 `logs/reproducibility_run/`。

第一次正式脚本尝试曾因多行 Tcl sink 字符串被 Innovus 19.10 误读为换行 term 而失败；该数据库未被继续使用。sink 列表改为规范 `[list ...]` 后，从新的 baseline 副本完整重跑通过。失败日志保存在 `logs/failed_attempt/`。

## 运行方式

在包含 `baseline/` 与 `inject_violation/` 的交付根目录中：

```bash
cd inject_violation/scenario_0004_max_fanout_delete_repeater
bash scripts/run_all.sh
```

也可以分别运行：

```bash
bash scripts/run_perturb.sh
bash scripts/run_validate_golden.sh
bash scripts/run_fresh_load_smoke.sh
```

runner 不以退出码单独判定成功，而是同时要求唯一完成标记、checkpoint 文件对及实际报告内容。仅当 `.integ.const` 的大小和内容都精确匹配 Innovus 19.10 已验证的 48-byte stub 时，runner 才将其规范化为空文件；数据库完整性检查没有被关闭。

## 原子任务

`atomic_tasks/manifest.json` 定义了 `tasks.md` 中自然适用的能力 2–10，共 9 项：根因、对象、动作、位置、副作用、Tcl 工具、闭环、失败恢复和停止决策。能力 1“时序报告理解”省略，因为主诊断证据是 fanout 与数据库拓扑；setup/hold 报告只承担副作用验收。

静态任务 7 项的参考答案均已通过；动态任务 7 和 9 均真实启动 Innovus，外层检查器同时验证完成标记、实际报告和数据库后置条件，参考提交均为 `PASS`。
