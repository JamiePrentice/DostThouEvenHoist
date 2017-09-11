#!/bin/bash
LazyBench='\n\033[1;33m[LazyBench]\033[0m -'

# Don't forget to "chmod +x benchmarks.sh" this file

printf "$LazyBench Starting Benchmark Scripts"

printf "$LazyBench Installing Sysbench..."
apt install sysbench -y & wait

printf "$LazyBench Running CPU Benchmarks... \n"
printf "\n----- CPU ------\n\n" >> results.txt
cat /proc/cpuinfo | grep 'model name' 2>&1 | tee -a results.txt
cat /proc/cpuinfo | grep 'cpu cores'  2>&1 | tee -a results.txt
cat /proc/cpuinfo | grep 'cpu MHz' 2>&1 | tee -a results.txt
cat /proc/cpuinfo | grep 'cache size' 2>&1 | tee -a results.txt
sysbench --test=cpu run >> results.txt & wait

printf "$LazyBench Memory Capacity: \n"
printf "\n----- Memory ------\n\n" >> results.txt
lshw -short -C memory 2>&1 | tee -a results.txt

printf "$LazyBench Running Memory Read Benchmarks... (This could take a while)"
printf "\n----- Memory Read ------\n\n" >> results.txt
sysbench --test=memory run >> results.txt & wait

printf "$LazyBench Running Memory Write Benchmarks... (This could also take a while)"
printf "\n----- Memory Write ------\n\n" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

printf "$LazyBench Disk Capacity: \n"
printf "\n----- Disk Capacity ------\n\n" >> results.txt
df -h 2>&1 | tee -a results.txt & wait

printf "$LazyBench Running Disk I/O Benchmarks..."
printf "\n----- DISK I/O ------\n\n" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

printf "$LazyBench Installing Python..."
apt install python-pip -y & wait
printf "$LazyBench Installing SpeedTest-Cli..."
pip install speedtest-cli & wait

printf "$LazyBench Running Network Benchmarks..."
printf "----- NETWORK ------\n\n" >> results.txt
printf "Network test 1: \n\n" >> results.txt
speedtest-cli >> results.txt & wait
printf "Network test 2: \n\n" >> results.txt
speedtest-cli >> results.txt & wait
printf "Network test 3: \n\n" >> results.txt
speedtest-cli >> results.txt & wait
printf "Network test 4: \n\n" >> results.txt
speedtest-cli >> results.txt & wait
printf "Network test 5: \n\n" >> results.txt
speedtest-cli >> results.txt & wait

printf "$LazyBench Uninstalling packages & clearing up \n"
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait
rm blackhole.txt & wait

printf "$LazyBench Done - Results in results.txt \n"
