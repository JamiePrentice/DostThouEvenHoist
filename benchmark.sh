#!/bin/bash
LazyBench='\n\033[1;33m[LazyBench]\033[0m -'

# Don't forget to "chmod +x benchmarks.sh" this file

printf "$LazyBench Starting Benchmark Scripts"

printf "$LazyBench Installing Sysbench..."
apt install sysbench -y >> blackhole.txt & wait

printf "$LazyBench Running CPU Benchmarks..."
printf "----- CPU ------\n\n" >> results.txt
sysbench --test=cpu run >> results.txt & wait

printf "$LazyBench Memory Capacity:"
lshw -short -C memory

printf "----- Memory ------\n\n" >> results.txt
lshw -short -C memory >> results.txt

printf "$LazyBench Running Memory Read Benchmarks... (This could take a while)"
printf "----- Memory Read ------\n\n" >> results.txt
sysbench --test=memory run >> results.txt & wait

printf "$LazyBench Running Memory Write Benchmarks... (This could also take a while)"
printf "----- Memory Write ------\n\n" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

printf "$LazyBench Disk Capacity:"
df -h

printf "----- Disk Capacity ------\n\n" >> results.txt
df -h >> results.txt & wait

printf "$LazyBench Running Disk I/O Benchmarks..."
printf "----- DISK I/O ------\n\n" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

printf "$LazyBench Installing Python..."
apt install python-pip -y >> blackhole.txt & wait
printf "$LazyBench Installing SpeedTest-Cli..."
pip install speedtest-cli >> blackhole.txt & wait

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

printf "$LazyBench Uninstalling packages & clearing up"
apt remove sysbench -y >> blackhole.txt & wait
apt remove python-pip -y >> blackhole.txt & wait
apt clean -y >> blackhole.txt & wait
apt autoremove -y >> blackhole.txt & wait
rm blackhole.txt & wait

printf "$LazyBench Done - Results in results.txt"
