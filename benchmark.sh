#!/bin/bash

# Don't forget to "chmod +x benchmarks.sh" this file

echo "Starting Benchmark Scripts"

apt -qq install sysbench -y & wait

echo "------ CPU ------" >> results.txt
sysbench --test=cpu run >> results.txt & wait

echo "------ Memory Read ------" >> results.txt
sysbench --test=memory run >> results.txt & wait

echo "------ Memory Write ------" >> results.txt
sysbench --test=memory --memory-oper=write run >> results.txt & wait

echo "------ DISK IO ------" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

echo "------ NETWORK ------" >> results.txt
apt install python-pip -y & wait
pip install speedtest-cli & wait
speedtest-cli >> results.txt & wait

echo "Uninstalling Packages"
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait

echo "Done - Results in results.txt"
