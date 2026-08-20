# hold_delete_repeaters 场景说明

## 场景目标

本场景在 `aes_cipher_top` routed baseline 上构造一个完全由物理数据路径变化引起的 Hold 违例。注入不修改 uncertainty、时钟周期、IO delay 或例外路径，而是错误删除最短数据路径上连续的两颗 repeater，使数据过早到达捕获寄存器。

正式验证使用 Cadence Innovus `19.10-p002_1`。

## Baseline 与候选试验

原始 baseline 的最差 Hold 路径为 `text_in[23] -> _19212_/D`，WNS/TNS 为 `+0.026/0 ns`；Setup WNS/TNS 为 `+0.390/0 ns`，DRV、placement、connectivity 和 DRC 均干净。

最初评估了“只把短路径单元升档”的更简单方案。即使将五级全部升到库中可用的更强 master，Hold WNS 仍为 `+0.018 ns`，无法形成违例，因此未采用。

随后从 untouched baseline 独立测试 repeater 删除候选：

| 候选 | Hold WNS | Setup WNS | 结论 |
| --- | ---: | ---: | --- |
| 只删 `FE_PHC917_00140` | `+0.001 ns` | `+0.390 ns` | 未违例 |
| 只删 `FE_PHC1249_00140` | `+0.005 ns` | `+0.390 ns` | 未违例 |
| 同时删除两颗 | `-0.019 ns` | `+0.390 ns` | 采用 |

## 正式注入

注入脚本 `perturb.tcl` 使用：

```tcl
ecoDeleteRepeater -inst FE_PHC917_00140
ecoDeleteRepeater -inst FE_PHC1249_00140
ecoRoute
extractRC
```

被删除对象为：

| 实例 | Master | 原始位置 |
| --- | --- | --- |
| `FE_PHC917_00140` | `CLKBUF_X1` | `(47.31, 19.88)` |
| `FE_PHC1249_00140` | `BUF_X1` | `(50.16, 25.48)` |

删除后 `_00140_` 直接驱动 `FE_PHC963_00140/A`，最差 Hold 路径仍为 `text_in[23] -> _19212_/D`，但最小数据到达时间减少并形成 `-0.019 ns` Hold 违例。注入状态的 Setup WNS 保持 `+0.390 ns`，且没有伴随 DRV、placement、connectivity 或 DRC 违例。

注入 checkpoint 为 `outputs/hold_delete_repeaters.enc(.dat)`。

## Golden repair

候选修复实测如下：

| 修复 | Hold WNS | 说明 |
| --- | ---: | --- |
| 插入一颗 `BUF_X1` | `+0.003 ns` | 闭合但裕量较小 |
| 插入一颗 `CLKBUF_X1` | `+0.006 ns`（正式重跑） | 采用，单颗且更稳健 |
| 插回两颗原始 repeater | `+0.028 ns` | 可闭合但属于过度 ECO |

Golden repair 在 `_00140_ -> FE_PHC963_00140/A` 分支、位置 `(47.31, 19.88)` 插入一颗 `CLKBUF_X1`：

```tcl
ecoAddRepeater \
    -term {FE_PHC963_00140/A} \
    -cell CLKBUF_X1 \
    -loc {47.31 19.88} \
    -name HOLD_FIX_CLKBUF_00140 \
    -newNetName HOLD_FIX_CLKBUF_00140_NET
refinePlace
ecoRoute
extractRC
```

修复后 Hold WNS/TNS 为 `+0.006/0 ns`，Setup WNS/TNS 为 `+0.390/0 ns`，DRV、placement、connectivity 和 DRC 全部闭合。修复 checkpoint 为 `outputs/golden_repaired.enc(.dat)`。

## 副作用

修复前后实际全局差异为：

- 标准单元数：`11771 -> 11772`；
- gate area：`15055.3 -> 15056.1 µm²`；
- total power：`19.23677394 -> 19.23709189 mW`；
- congestion overflow：`1 -> 1`；
- Setup WNS：`+0.390 -> +0.390 ns`。

## 可复现性与子能力

注入、修复及两个 checkpoint 的 fresh-load 均已通过。又从同一 untouched 输入包在独立 VM 目录完整重跑一次，复现得到相同的 `-0.019 ns` 注入 Hold WNS 和 `+0.006 ns` 修复 Hold WNS。

本场景构建 `tasks.md` 中全部 10 项子能力。第 5 项位置选择由 `_00140_` 的目标 sink 分支和实际 buffer 位置提供可验证标签；动态任务 7 和 9 会真实启动 Innovus，并检查对象状态、Setup/Hold、DRV、placement、connectivity 和 DRC。
