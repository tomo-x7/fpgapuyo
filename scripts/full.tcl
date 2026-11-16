# ==============================================================================
# 設定と初期化
# ==============================================================================
set PART "xc7a35tcpg236-1"
set TOP_MODULE "main"
set_msg_config -severity {INFO} -suppress

# LinuxのCPUコアをフルに使う設定
set_param general.maxThreads 8

# 時間計測用の関数 (バックスラッシュでエスケープ修正)
proc print_elapsed_time {step_name start_time} {
    set end_time [clock seconds]
    set elapsed [expr {$end_time - $start_time}]
    set min [expr {$elapsed / 60}]
    set sec [expr {$elapsed % 60}]
    puts "--> \[INFO\] === ${step_name} 完了 (所要時間: ${min}分 ${sec}秒) ==="
}

set total_start [clock seconds]
create_project -in_memory -part $PART

# ==============================================================================
# 1. ソースファイル・制約の読み込み
# ==============================================================================
set start [clock seconds]

# Verilog (.v) ファイルの読み込み
set v_files [glob -nocomplain ./src/*.v]
if {[llength $v_files] > 0} { read_verilog $v_files }

# SystemVerilog (.sv) ファイルの読み込み
set sv_files [glob -nocomplain ./src/*.sv]
if {[llength $sv_files] > 0} { read_verilog -sv $sv_files }

# 制約 (.xdc) ファイルの読み込み
set xdc_files [glob -nocomplain ./src/*.xdc]
if {[llength $xdc_files] > 0} { read_xdc $xdc_files }

print_elapsed_time "ファイル読み込み" $start

# ==============================================================================
# 2. 論理合成 (Synthesis)
# ==============================================================================
set start [clock seconds]
puts "--> \[INFO\] 論理合成を実行中..."
synth_design -top $TOP_MODULE -part $PART
print_elapsed_time "論理合成 (synth_design)" $start

file mkdir ./out

# ==============================================================================
# 3. 最適化・配置・配線 (Implementation)
# ==============================================================================
set start [clock seconds]
puts "--> \[INFO\] 最適化 (opt_design) を実行中..."
opt_design
print_elapsed_time "最適化 (opt_design)" $start

set start [clock seconds]
puts "--> \[INFO\] 配置 (place_design) を実行中..."
place_design
print_elapsed_time "配置 (place_design)" $start

set start [clock seconds]
puts "--> \[INFO\] 配線 (route_design) を実行中..."
route_design
print_elapsed_time "配線 (route_design)" $start

# ==============================================================================
# 4. ビットストリーム生成 (write_bitstream)
# ==============================================================================
set start [clock seconds]
puts "--> \[INFO\] ビットストリームを生成中..."
set_property BITSTREAM.GENERAL.COMPRESS FALSE [current_design]

write_bitstream -force ./out/main.bit

print_elapsed_time "ビットストリーム生成 (write_bitstream)" $start

# ==============================================================================
# 全体終了
# ==============================================================================
print_elapsed_time "=== すべての工程 ===" $total_start
