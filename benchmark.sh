#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Don't forget to "chmod +x benchmarks.sh" this file

echo -e "${YELLOW}[LazyBench]${NC} - Starting Benchmark Scripts"
echo -e "${YELLOW}[LazyBench]${NC} - Installing Sysbench..."

apt install -qq sysbench -y & wait

echo -e "${YELLOW}[LazyBench]${NC} - Running CPU Benchmarks..."
echo "------ CPU ------" >> results.txt
sysbench --test=cpu run >> results.txt & wait

echo -e "${YELLOW}[LazyBench]${NC} - Running Memory Read Benchmarks... (This could take a while)"
echo "------ Memory Read ------" >> results.txt
sysbench --test=memory run >> results.txt & wait

echo -e "${YELLOW}[LazyBench]${NC} - Running Memory Write Benchmarks... (This could also take a while)"
echo "------ Memory Write ------" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

echo -e "${YELLOW}[LazyBench]${NC} - Running Disk I/O Benchmarks..."
echo "------ DISK I/O ------" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

echo -e "${YELLOW}[LazyBench]${NC} - Installing Python and Speedtest-CLI..."
apt install python-pip -y & wait
pip install speedtest-cli & wait
echo -e "${YELLOW}[LazyBench]${NC} - Running Memory Read Benchmarks..."
echo "------ NETWORK ------" >> results.txt
speedtest-cli >> results.txt & wait

echo -e "${YELLOW}[LazyBench]${NC} - Uninstalling packages & clearing up"
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait

echo -e "${YELLOW}[LazyBench]${NC} - Done - Results in results.txt"
