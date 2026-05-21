#!/bin/bash

# 检查 perf.data 文件是否存在
if [ ! -f "perf.data" ]; then
    echo "错误: perf.data 文件不存在"
    exit 1
fi

# 检查 FlameGraph 文件夹，不存在则克隆
if [ ! -d "FlameGraph" ]; then
    echo "正在克隆 FlameGraph 仓库..."
    git clone https://github.com/brendangregg/FlameGraph.git
    if [ $? -ne 0 ]; then
        echo "错误: 克隆 FlameGraph 失败"
        exit 1
    fi
fi

# 创建 out 文件夹
mkdir -p out

# 生成带时间戳的文件名
timestamp=$(date +%Y%m%d_%H%M%S)
output_file="out/${timestamp}.svg"

# 执行命令生成火焰图
echo "正在生成火焰图..."
perf_output=$(perf script 2>&1)
perf_exit_code=$?

if [ $perf_exit_code -ne 0 ]; then
    if echo "$perf_output" | grep -q "failed to open perf.data: Permission denied"; then
        echo "错误: perf.data 文件权限不足"
        echo "提示: 请执行以下命令赋予权限:"
        echo "  sudo chmod 644 perf.data"
        echo "或者使用 sudo 运行此脚本"
    else
        echo "错误: $perf_output"
    fi
    exit 1
fi

echo "$perf_output" | FlameGraph/stackcollapse-perf.pl | FlameGraph/flamegraph.pl > "$output_file"

if [ $? -eq 0 ]; then
    echo "火焰图已生成: $output_file"
else
    echo "错误: 生成火焰图失败"
    exit 1
fi
