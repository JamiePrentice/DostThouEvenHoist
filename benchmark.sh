#!/bin/bash
LazyBench='\n\033[1;33m[LazyBench]\033[0m -'

# Don't forget to "chmod +x benchmarks.sh" this file

printf "$LazyBench Starting Benchmark Scripts"

printf "$LazyBench Installing Sysbench..."
apt install sysbench -y & wait

printf "$LazyBench Running CPU Benchmarks..."
printf "\n----- CPU ------\n" >> results.txt
sysbench --test=cpu run >> results.txt & wait

printf "$LazyBench Memory Capacity:"
lshw -short -C memory

printf "\n----- Memory ------\n" >> results.txt
lshw -short -C memory >> results.txt

printf "$LazyBench Running Memory Read Benchmarks... (This could take a while)"
printf "\n----- Memory Read ------\n" >> results.txt
sysbench --test=memory run >> results.txt & wait

printf "$LazyBench Running Memory Write Benchmarks... (This could also take a while)"
printf "\n----- Memory Write ------\n" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

printf "$LazyBench Disk Capacity:"
df -h

printf "\n----- Disk Capacity ------\n" >> results.txt
df -h >> results.txt & wait

printf "$LazyBench Running Disk I/O Benchmarks..."
printf "\n----- DISK I/O ------\n" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

printf "$LazyBench Installing Python and Speedtest-CLI..."
apt install python-pip -y & wait
pip install speedtest-cli & wait

printf "$LazyBench Running Network Benchmarks..."
printf "\n----- NETWORK ------\n" >> results.txt
printf "\n Network test 1: \n" >> results.txt
speedtest-cli >> results.txt & wait
printf "\n Network test 2: \n" >> results.txt
speedtest-cli >> results.txt & wait
printf "\n Network test 3: \n" >> results.txt
speedtest-cli >> results.txt & wait
printf "\n Network test 4: \n" >> results.txt
speedtest-cli >> results.txt & wait
printf "\n Network test 5: \n" >> results.txt
speedtest-cli >> results.txt & wait

printf "$LazyBench Uninstalling packages & clearing up"
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait

printf "$LazyBench Done - Results in results.txt"
