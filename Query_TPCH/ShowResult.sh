#!/bin/bash

# 
#  
#
#  @project     PerfmonSQL
#  @package     ShowResult 
#  @subpackage
#  @access     
#  @paramtype   
#  @argument    Query Number [Query 1 to 22 - 0 for all Query in synchronous mode ] - Mode Power or Throughput [ 0 : Power - 1 : Throughput - 2 : Single Requets]
#  @description Show Results TPC-H Query 
#
#  @author Emmanuel COLUSSI
#  @version 1.00
#  @Copyright 2016 Hewlett Packard Enterprise
#  @test    http://localhost:3008
# 
# 


if [ "$#" -ne 2 ]; then
        printf " Error : Usage : ShowResult.sh [ Query Number 1 to 22 - 0 for all Query in synchronous mode] [ Mode : 0 : Power - 1 : Throughput - 2 : Single Request] \n\007"
        exit
fi

if [ $1 -gt "22" ]; then
        printf " Error : [ Query Number <= 22]\n\007"
        exit
fi

if [ $1 -eq 0 ]
then
 if [ $2 -eq 1 ] 
 then
    QUERYRESULT="ResultThroughput.txt"
    echo "Query;Time ms;vUsers" > Results_throughput.txt 
    for rq in $(seq 1 22)
    do
	nbs=0
	nbtrans=`cat $QUERYRESULT |grep -w Request$rq|wc -l`
        GetTime=`cat $QUERYRESULT |grep -w Request$rq|cut -d'=' -f5|cut -d' ' -f1`	
        for i in $GetTime
        do
                nbs=`expr $nbs + $i`
        done

        echo "Query$rq Run in : $nbs ms By $nbtrans vUsers"
	echo "Query$rq;$nbs;$nbtrans" >> Results_throughput.txt
    done 	
 else
    QUERYRESULT="ResultPower.txt"
    GetTime=`cat $QUERYRESULT |cut -d'=' -f5|cut -d' ' -f1`
    echo "Query;Time ms" > Results_power.txt 
     iq=1	
    for j in $GetTime
    do
	echo "Query$iq run in $j ms"
	echo "Query$iq;$j" >> Results_power.txt
        iq=$(expr $iq + 1)
    done	
 fi
else
	echo "Query;Time ms;vUsers" > Results_single.txt
	QPREFIX="QDB_Query_"
	QUERYRESULT="ResultQuery$1.txt"
	GetTime=`cat $QUERYRESULT |cut -d'=' -f5|cut -d' ' -f1`
	nbtrans=`cat $QUERYRESULT|wc -l`
	nbs=0

	for i in $GetTime
	do
		nbs=`expr $nbs + $i`
	done

	echo "Query$1 Run in : $nbs ms By $nbtrans vUsers"
	echo "Query$1;$nbs;$nbtrans" >> Results_single.txt
fi