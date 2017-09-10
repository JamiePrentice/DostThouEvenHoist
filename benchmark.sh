#!/bin/bash

# Don't forget to "chmod +x benchmarks.sh" this file

echo "Starting Benchmark Scripts"
echo "Installing Sysbench..."

apt install -qq sysbench -y & wait

echo "Running CPU Benchmarks... (This could take a while)"
echo "------ CPU ------" >> results.txt
sysbench --test=cpu run >> results.txt & wait

echo "Running Memory Read Benchmarks..."
echo "------ Memory Read ------" >> results.txt
sysbench --test=memory run >> results.txt & wait

echo "Running Memory Write Benchmarks..."
echo "------ Memory Write ------" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

echo "Running Disk I/O Benchmarks..."
echo "------ DISK I/O ------" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

echo "Installing Python and Speedtest-CLI..."
apt install python-pip -y & wait
pip install speedtest-cli & wait
echo "Running Memory Read Benchmarks..."
echo "------ NETWORK ------" >> results.txt
speedtest-cli >> results.txt & wait

echo "Uninstalling packages & clearing up"
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait

echo "Done - Results in results.txt"
