#!/bin/bash
LazyBench='\033[1;33m[LazyBench]\033[0m -'

# Don't forget to "chmod +x benchmarks.sh" this file

echo -e "$LazyBench Starting Benchmark Scripts"

echo -e "$LazyBench Installing Sysbench..."
apt install sysbench -y & wait

echo -e "$LazyBench Running CPU Benchmarks..."
echo "\\n----- CPU ------\\n" >> results.txt
sysbench --test=cpu run >> results.txt & wait

echo -e "$LazyBench Memory Capacity:"
lshw -short -C memory

echo "\\n----- Memory ------\\n" >> results.txt
lshw -short -C memory >> results.txt

echo -e "$LazyBench Running Memory Read Benchmarks... (This could take a while)"
echo "\\n----- Memory Read ------\\n" >> results.txt
sysbench --test=memory run >> results.txt & wait

echo -e "$LazyBench Running Memory Write Benchmarks... (This could also take a while)"
echo "\\n----- Memory Write ------\\n" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

echo -e "$LazyBench Disk Capacity:"
df -h

echo "\\n----- Disk Capacity ------\\n" >> results.txt
df -h >> results.txt & wait

echo -e "$LazyBench Running Disk I/O Benchmarks..."
echo "\\n----- DISK I/O ------\\n" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

echo -e "$LazyBench Installing Python and Speedtest-CLI..."
apt install python-pip -y & wait
pip install speedtest-cli & wait

echo -e "$LazyBench Running Network Benchmarks..."
echo "\\n----- NETWORK ------\\n" >> results.txt
echo "\\n Network test 1: \\n" >> results.txt
speedtest-cli >> results.txt & wait
echo "\\n Network test 2: \\n" >> results.txt
speedtest-cli >> results.txt & wait
echo "\\n Network test 3: \\n" >> results.txt
speedtest-cli >> results.txt & wait
echo "\\n Network test 4: \\n" >> results.txt
speedtest-cli >> results.txt & wait
echo "\\n Network test 5: \\n" >> results.txt
speedtest-cli >> results.txt & wait

echo -e "$LazyBench Uninstalling packages & clearing up"
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait

echo -e "$LazyBench Done - Results in results.txt"
