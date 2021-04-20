# TPC-H benchmark tools Microsoft SQL Server Linux
This repository facilitates the use of the TPC-H benchmark.


It's posible to run Query in :
* single mode : 1 Query run sequentially or simulate multiple users who execute the same query in parallel
* power mode  : 22 queries run sequentially, in single stream. 
* throughput mode :  X amount of streams, each running the 22 queries in parallel

Get the results and calculating the QppH

## Requirements

* The Bourne Again Shell - bash
* various typical Unix-shell command-line tools: unzip, sed, echo and so on
* Microsoft SQL Server instance up
* Database TPC-H create database and loaded data

## Getting started

Edit script ***RunQuery.sh*** and initialize the following variables :
```
LOGIN=[ login user database ]
PASS=[ Password ] 
BASE=[ Database Name ]
HOSTNAME=[ Hostname ]
```
Run Workload : Query in single mode , power mode or throughput mode

```
./RunQuery.sh [ Run Name ] [ Number iteration ] [ Query Number ] 
```
```
[ Run Name ] : String name of run
[ Number iteration ] : Number de run in parallel
[ Query Number ] : 1 to 22 - 0 for all Query in synchronous mode
```
Show Results

```
./ShowResult.sh [ Query Number ] [ Mode ]
```
```
[ Query Number ] : 1 to 22 - 0 for all Query in synchronous mode
[ Mode ] : 0 : Power - 1 : Throughput - 2 : Single
```
This script generate 1 csv file per mode :
```
Power      : Results_power.txt
Throughput : Results_throughput.txt
Single     : Results_single.txt
```
for calculating the QppH use the file TPC-H-Calculator.xls
