set PART "xc7a35tcpg236-1"
set TOP_MODULE "main"

create_project -in_memory -part $PART
# 1. Verilog (.v) ファイルの読み込み
set v_files [glob -nocomplain ./src/*.v]
if {[llength $v_files] > 0} {
    read_verilog $v_files
}

# 2. SystemVerilog (.sv) ファイルの読み込み
set sv_files [glob -nocomplain ./src/*.sv]
if {[llength $sv_files] > 0} {
    read_verilog -sv $sv_files
}

set xci_files [glob -nocomplain ./ip/*.xci ./ip/*/*.xci]
puts "見つかったファイル: $xci_files"
if {[llength $xci_files] > 0} {
    read_ip $xci_files
	set locked_ips [get_ips -filter {IS_LOCKED == 1}]
    if {[llength $locked_ips] > 0} {
        puts "--> Upgrading locked IPs: $locked_ips"
        upgrade_ip $locked_ips
    }
	set_property generate_synth_checkpoint false [get_files $xci_files]
    generate_target all [get_ips]
	set ip_gen_v [glob -nocomplain ./ip/*/*.v ./ip/*/*/*.v]
    if {[llength $ip_gen_v] > 0} {
        read_verilog $ip_gen_v
    }
}

# 3. 制約 (.xdc) ファイルの読み込み
set xdc_files [glob -nocomplain ./src/*.xdc]
if {[llength $xdc_files] > 0} {
    read_xdc $xdc_files
}

synth_design -top $TOP_MODULE -part $PART

# 合成結果をチェックポイントとして保存
file mkdir ./out
write_checkpoint -force ./out/post_synth.dcp