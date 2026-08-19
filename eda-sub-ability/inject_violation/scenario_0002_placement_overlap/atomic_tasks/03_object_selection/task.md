# ECO 对象选择

结合 `inputs/original_locations.tsv` 与 `inputs/current_overlap.tsv`，选择应恢复的单元和不应移动的锚点单元。将 `selected_instance`、`do_not_move` 和 `reason` 写入 `answer.json`。目标是以最小编辑恢复 baseline 物理状态。

