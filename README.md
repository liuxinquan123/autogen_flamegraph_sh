# autogen_flamegraph_sh
1. perf.data和脚本放在同一级目录下；
2. 执行autogen_flamegraph_sh，会先检测是否存在perf.data；
3. 满足2条件下，会判断是否存在FlameGraph，不存在会自动下载；
4. 自动解析perf.data，并把结果生成在out目录下
