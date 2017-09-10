#!/bin/bash

# Don't forget to "chmod +x benchmarks.sh" this file

echo "Starting Benchmark Scripts"

y | apt install sysbench & wait

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
y | apt install apache2-utils & wait
ab -kc 1000 -n 10000 http://127.0.0.1/ & wait

echo "\n ------ NETWORK ------" &>> results.txt
apt install python-pip & wait
pip install speedtest-cli & wait
speedtest-cli >> results.txt & wait

echo "\n ------ UnixBench ------" >> results.txt
git clone https://github.com/kdlucas/byte-unixbench.git & wait
make -C byte-unixbench/UnixBench/ & wait
cd byte-unixbench/UnixBench/
./Run >> ../../results.txt & wait
cd ../../

echo "Uninstalling Packages"
rm -R byte-unixbench
y | apt remove sysbench & wait
y | apt remove python-pip & wait
y | apt clean & wait
y | apt autoremove & wait

echo "Done - Results in results.txt"
