# 合成済みのチェックポイントを読み込む
open_checkpoint ./out/post_synth.dcp

opt_design
place_design
route_design

# 配置配線結果をチェックポイントとして保存
write_checkpoint -force ./out/post_impl.dcp