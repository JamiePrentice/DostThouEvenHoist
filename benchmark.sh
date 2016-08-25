#!/bin/bash

# Don't forget to "chmod +x benchmarks.sh" this file
echo "Starting Benchmark Scripts"

echo "\n------ CPU ------" > results.txt
y | apt install sysbench & wait
sysbench --test=cpu --cpu-max-prime=20000 run >> results.txt & wait
sysbench --test=fileio --file-total-size=1G prepare & wait

echo "\n------ DISK IO ------" >> results.txt
sysbench --test=fileio --file-total-size=1G --file-test-mode=rndrw --init-rng=on --max-time=120 --max-requests=0 run >> results.txt & wait
sysbench --test=fileio --file-total-size=1G cleanup & wait

echo "\n------ NETWORK ------" &>> results.txt
apt install python-pip & wait
pip install speedtest-cli & wait
speedtest-cli >> results.txt & wait

echo "\n------ UnixBench ------" >> results.txt
git clone https://github.com/kdlucas/byte-unixbench.git & wait
make -C byte-unixbench/UnixBench/ & wait
cd byte-unixbench/UnixBench/
./Run >> ../../results.txt & wait
cd ../../

echo "Uninstalling Packages"
rm -R byte-unixbench
y | apt remove sysbench & wait
y | apt remove python-pip & wait
