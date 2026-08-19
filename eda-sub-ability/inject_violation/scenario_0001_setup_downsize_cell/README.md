# setup_downsize_cell 场景说明

## 1. 场景目标

本场景用于构造一个由关键路径连续三级驱动单元被错误降档所引起的 setup 违例，并提供能够同时修复 setup、transition 和 capacitance 的配套 cell-sizing ECO。

原始 baseline 的 setup WNS 为 `+0.390 ns`，时序裕量较大。候选试验表明，单独 downsize 一个数据路径单元不足以产生 setup 违例，因此场景采用“连续三级关键路径单元 + 可控电容负载”的构造方式。

## 2. 负载与干净准备状态

首先将三个关键路径实例设置为较强的 X4 单元：

| 实例 | 输出网络 | 准备状态单元 |
|---|---|---|
| `_16419_` | `_07405_` | `OAI21_X4` |
| `_16425_` | `_07411_` | `OAI221_X4` |
| `_16427_` | `_07413_` | `OAI21_X4` |

随后在每个输出网络上连接 4 个 `BUF_X8` 的输入端作为固定电容负载，共增加 12 个负载实例。完成合法化、增量布线和 RC 提取后，该准备状态仍然干净：

- setup WNS/TNS：`+0.276 / 0 ns`
- hold WNS/TNS：`+0.026 / 0 ns`
- constraint violations：0

因此，负载夹具本身不会产生目标违例。

## 3. 违例注入

真正的故障注入是将上述连续三级单元从 X4 降为 X1：

| 实例 | 注入前 | 注入后 |
|---|---|---|
| `_16419_` | `OAI21_X4` | `OAI21_X1` |
| `_16425_` | `OAI221_X4` | `OAI221_X1` |
| `_16427_` | `OAI21_X4` | `OAI21_X1` |

降档后，三个单元的驱动能力下降，输出 transition 变差，cell/net delay 增大；这些延迟在同一条关键路径上连续累积，最终形成 setup 违例。

注入后的主要结果如下：

- setup WNS/TNS：`-0.045 / -0.045 ns`
- 最差 setup 路径：`_19477_/Q -> _19318_/D`
- path group：`aes_clk`
- analysis view：`VIEW_TYP`
- max transition 违例端点：13 个
- max capacitance 违例输出：3 个
- real max fanout violations：0
- hold WNS/TNS：`+0.026 / 0 ns`
- placement、connectivity、DRC：全部干净

setup 是本场景的主要违例；transition 和 capacitance 是相同弱驱动根因产生的伴随 DRV。

注入脚本为 `perturb.tcl`，生成的场景 checkpoint 为：

- `outputs/setup_downsize_cell.enc`
- `outputs/setup_downsize_cell.enc.dat/`

## 4. 配套修复

修复时保留负载夹具，仅纠正错误的 cell sizing，将三个 X1 单元恢复为 X4：

```tcl
ecoChangeCell -inst _16419_ -cell OAI21_X4
ecoChangeCell -inst _16425_ -cell OAI221_X4
ecoChangeCell -inst _16427_ -cell OAI21_X4
```

修改后执行完整的增量物理闭环：

```tcl
refinePlace
ecoRoute
extractRC
```

完整修复脚本为 `golden_repair.tcl`。

## 5. 修复结果

- setup WNS/TNS：`+0.275 / 0 ns`
- hold WNS/TNS：`+0.026 / 0 ns`
- transition/capacitance constraints：全部闭合
- placement、connectivity、DRC：全部通过

修复后的 checkpoint 为：

- `outputs/golden_repaired.enc`
- `outputs/golden_repaired.enc.dat/`

整体因果关系如下：

```text
连续三级 X4 被错误降为 X1
        ↓
驱动能力下降，transition 变差，cell/net delay 增加
        ↓
关键路径累积产生 -0.045 ns setup 违例
        ↓
将三个单元恢复为 X4，并重新合法化、布线和提取 RC
        ↓
setup、hold、DRV 和物理检查全部闭合
```

## 6. 原子子能力

本场景构造了 `tasks.md` 中适用的 9 项子能力：`1、2、3、4、6、7、8、9、10`。

第 5 项物理插入位置选择不适用于纯 cell-sizing 修复，因此没有强行构造。具体任务索引见 `atomic_tasks/manifest.json`。
