#!/bin/bash

# Don't forget to "chmod +x benchmarks.sh" this file

echo "Starting Benchmark Scripts"

apt install sysbench -y & wait

echo "\n ------ CPU ------" > results.txt
sysbench --test=cpu run >> results.txt & wait

echo "\n ------ Memory Read ------" > results.txt
sysbench --test=memory run & wait

echo "\n ------ Memory Write ------" > results.txt
sysbench --test=memory --memory-oper=write run & wait

echo "\n ------ DISK IO ------" >> results.txt
sysbench --test=fileio prepare & wait
sysbench --test=fileio --file-test-mode=rndrw run >> results.txt & wait
sysbench --test=fileio cleanup & wait

echo "\n ------ Apache -------" &>> results.txt
apt install apache2-utils -y & wait
ab -kc 1000 -n 10000 http://127.0.0.1/ & wait

echo "\n ------ NETWORK ------" &>> results.txt
apt install python-pip & wait
pip install speedtest-cli & wait
speedtest-cli >> results.txt & wait

echo "Uninstalling Packages"
rm -R byte-unixbench
apt remove sysbench -y & wait
apt remove python-pip -y & wait
apt clean -y & wait
apt autoremove -y & wait

echo "Done - Results in results.txt"
