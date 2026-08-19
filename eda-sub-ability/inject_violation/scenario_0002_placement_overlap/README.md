# placement_overlap 场景说明

## 场景与基线

本场景在 `aes_cipher_top` 的 routed baseline 上构造可保存、可 fresh-load、可精确回滚的标准单元 placement overlap。正式运行使用 Cadence Innovus `19.10-p002_1`。

原始 baseline 的检查结果为：`checkPlace` 无 overlap、`Unplaced = 0`，connectivity 无问题，DRC 为 0；PostRoute setup WNS/TNS 为 `+0.390/0 ns`，hold WNS/TNS 为 `+0.026/0 ns`，DRV 无 `VIOLATED` 项。对应证据位于 `reports/prepared/`。

## 候选试验

三个候选均为非 fixed、`placed/core/core` 普通逻辑单元，并分别从原始 baseline 独立运行：

| 候选 | mover → target | master | 结果 |
| --- | --- | --- | --- |
| A | `_14522_` → `_14662_` | `NOR2_X1` → `NOR2_X1` | overlap=2；fresh-load 保留；回移后全检查通过；采用 |
| B | `_13944_` → `_13932_` | `NAND2_X1` → `NAND2_X1` | overlap=2；fresh-load 保留；回移后全检查通过；注入 DRC 为 3，未采用 |
| C | `_18717_` → `_18539_` | `OAI21_X1` → `OAI21_X1` | overlap=2；fresh-load 保留；回移后全检查通过；未采用 |

初次解析曾失败一次：Innovus 19.10 的 `checkPlace` 只报告 overlap 对象数量，不打印实例名。正式验证因此同时检查 `checkPlace` 数量和数据库中目标坐标上的实例集合，避免用文本猜测对象。完整证据见 `reports/candidate_trials/summary.json` 及各候选目录。

## 正式注入

两个实例尺寸均为 `0.57 × 1.40 µm`：

| 角色 | 实例 | 原始位置 | 原始方向 | 状态 |
| --- | --- | --- | --- | --- |
| mover | `_14522_` | `(32.68, 119.28)` | `R180` | placed，非 fixed，core/core |
| target | `_14662_` | `(33.25, 119.28)` | `MX` | placed，非 fixed，core/core |

`perturb.tcl` 使用 `placeInstance` 将 `_14522_` 移到 `(33.25, 119.28)`，保持 `R180`，使它与 `_14662_` 完全占用同一起点。注入后：

- `checkPlace`：`Overlapping with other instance: 2`，`Unplaced = 0`；
- 数据库坐标查询：对象恰为 `_14522_`、`_14662_`；
- setup/hold WNS/TNS：`+0.390/0 ns`、`+0.026/0 ns`；
- DRV：无 `VIOLATED` 项；
- connectivity：移动单元三个 pin 产生 9 条 open/dangling 信息；
- DRC：2 个 metal1 short。

这些 connectivity/DRC 是移动 routed cell 的预期伴随副作用，并在修复验收中必须归零。注入 checkpoint 为 `outputs/placement_overlap.enc(.dat)`。

## Golden repair 与验证

`golden_repair.tcl` 只把 `_14522_` 精确恢复到 `(32.68,119.28) R180`，随后重新 `extractRC`。不调用全局合法化，因此修复动作可解释且不会无谓移动其他单元。

修复后的 `checkPlace` 无 overlap 且 `Unplaced = 0`，connectivity 无问题，DRC 为 0，DRV 无违例；setup/hold WNS/TNS 恢复为 `+0.390/0 ns` 与 `+0.026/0 ns`。修复 checkpoint 为 `outputs/golden_repaired.enc(.dat)`。

注入 checkpoint 和修复 checkpoint 均在独立 Innovus 进程中 fresh-load 成功。正式流程又从未运行过的 baseline 副本完整重跑一次，关键 overlap、对象、timing、DRC、connectivity 与修复结果完全一致；证据位于 `reports/reproducibility_run/` 和 `logs/reproducibility_run/`。runner 仅对 Innovus 19.10 已知的 48-byte `.integ.const` stub 做 scenario_0001 已验证的精确修正，未关闭数据库完整性检查。

## 原子子能力

本场景构建能力 `2–10` 共 9 项。能力 1 未构造：主违例是可由 `checkPlace` 和几何数据库直接证明的 placement overlap，setup/hold 报告只用于副作用验收，不是定位或选择 ECO 的驱动证据。动态任务 7 和 9 会真实启动 Innovus，并同时检查唯一完成标记及实际 placement、connectivity、DRC、DRV、setup、hold 报告。

