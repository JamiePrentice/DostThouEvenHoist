#!/bin/bash
LazyBench='\n\033[1;33m[LazyBench]\033[0m -'

printf "$LazyBench Installing dependencies"

printf "$LazyBench Installing Sysbench..."
apt-get install sysbench -y > /dev/null & wait
printf "$LazyBench Installing lshw..."
apt-get install lshw -y > /dev/null & wait
printf "$LazyBench Installing Python..."
apt-get install python-pip -y > /dev/null & wait
printf "$LazyBench Installing SpeedTest-Cli..."
pip install speedtest-cli > /dev/null & wait

clear

printf "$LazyBench Starting Benchmark Scripts... \n"

printf "$LazyBench Running CPU Benchmarks... \n\n"
printf "\n######## CPU ########\n\n" >> results.txt
cat /proc/cpuinfo | grep 'model name' 2>&1 | tee -a results.txt
cat /proc/cpuinfo | grep 'cpu cores'  2>&1 | tee -a results.txt
cat /proc/cpuinfo | grep 'cpu MHz' 2>&1 | tee -a results.txt
cat /proc/cpuinfo | grep 'cache size' 2>&1 | tee -a results.txt
sysbench cpu --cpu-max-prime=25000 run >> results.txt & wait
sysbench cpu --cpu-max-prime=25000 run --num-threads=4 >> results.txt & wait

printf "$LazyBench Memory Capacity: \n\n"
printf "\n######## Memory ########\n\n" >> results.txt
lshw -short -C memory 2>&1 | tee -a results.txt

printf "$LazyBench Running Memory Read Benchmarks... (This could take a while) \n"
printf "\n######## Memory Read ########\n\n" >> results.txt
sysbench memory --memory-oper=read run >> results.txt & wait

printf "$LazyBench Running Memory Write Benchmarks... (This could also take a while) \n"
printf "\n######## Memory Write ########\n\n" >> results.txt
sysbench memory --memory-oper=write run >> results.txt & wait

printf "$LazyBench Disk Capacity: \n\n"
printf "\n######## Disk Capacity ########\n\n" >> results.txt
df -h 2>&1 | tee -a results.txt & wait

printf "$LazyBench Running Disk I/O Benchmarks..."
printf "\n######## DISK I/O ########\n\n" >> results.txt
sysbench fileio prepare > /dev/null & wait
sysbench fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench fileio cleanup > /dev/null & wait

printf "$LazyBench Running Network Benchmarks...\n"
printf "\n######## NETWORK ########\n\n" >> results.txt
speedtest-cli >> results.txt & wait

printf "$LazyBench Uninstalling packages & clearing up \n\n"
apt-get remove sysbench -y > /dev/null & wait
apt-get remove python-pip -y > /dev/null & wait
apt-get clean -y > /dev/null & wait
apt-get autoremove -y > /dev/null & wait

printf "$LazyBench Done - Results in results.txt \n"
