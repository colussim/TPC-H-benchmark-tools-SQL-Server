#!/bin/bash

# 
#  
#
#  @project     PerfmonSQL
#  @package     RunQuery 
#  @subpackage
#  @access      tpch
#  @paramtype   Login : [sa] Password :[] DataBase : [TPCH] HOSTNAME : [SQL Server ip Address]
#  @argument    Run Name :[String without space] - Iteration Number : vUsers - Query Number [Query 1 to 22 - 0 for all Query in synchronous mode ]
#  @description Run TPC-H Query 
#
#  @author Emmanuel COLUSSI
#  @version 1.00
#  @Copyright 2017 Hewlett Packard Enterprise
#  @test    http://localhost:3008
# 
# 

if [ "$#" -ne 3 ]; then
        printf " Error : Usage : RunQuery.sh [ run name ] [ number iteration ] [ Query Number 1 to 22 - 0 for all Query in synchronous mode]\n\007"
        exit
fi

if [ $3 -gt "22" ]; then
        printf " Error : [ Query Number <= 22]\n\007"
        exit
fi

waitPids() {
    while [ ${#pids[@]} -ne 0 ]; do
        #echo "Waiting for pids: ${pids[@]}"
        local range=$(eval echo {0..$((${#pids[@]}-1))})
        local i
        for i in $range; do
            if ! kill -0 ${pids[$i]} 2> /dev/null; then
		idx=${pids[$i]}
                echo "End Transaction ${transs[$idx]}  -- PID : ${pids[$i]} -- " `date +"%Y-%m-%d %H:%M:%S,%3N"`
                unset pids[$i]
            fi
        done
        pids=("${pids[@]}") 
        sleep 1
    done
    echo "Run Done!"
}

addPid() {
    desc=$1
    trans=$2	
    pid=$3
    echo "$desc -- PID : $pid -- " `date +"%Y-%m-%d %H:%M:%S,%3N"`
    pids=(${pids[@]} $pid)
    transs[$pid]=$trans
}


if [ $3 -gt "22" ]; then
        printf " Error : [ Query Number <= 22]\n\007"
	exit
fi


LOGIN=""
PASS=""
#BASE="TPCH100g"
BASE="TPCH"
HOSTNAME="10.6.29.80"
QPREFIX="QDB_Query_"
QUERYRESULT="ResultQuery$3.txt"
RunName=$1

declare -A transs

if [ $3 -eq 0 ]
then
 if [ $2 -gt 1 ] 
 then
    QUERYRESULT="ResultThroughput.txt"
    cat /dev/null > $QUERYRESULT
 else
    QUERYRESULT="ResultPower.txt"
    cat /dev/null > $QUERYRESULT
 fi
	for i in $(seq 1 $2);
        do
		( for nrq in $(seq 1 22);
		do
			QUERYName=`sed -e '1,4d' $QPREFIX$nrq.sql`
			RequestIDX="Request$nrq"
			REQUEST="$RunName,host=$HOSTNAME,request=$RequestIDX,transaction=$i nvalue="
			ntimestamp=`date +%s%9N`
                	sqlcmd -U $LOGIN -P $PASS -d $BASE -S $HOSTNAME -p  -Q "
                	BEGIN TRAN T$i;
                	SET FMTONLY OFF;
                	SET NOCOUNT ON;
                	BEGIN
                       		 $QUERYName
			END
			COMMIT TRAN T$i;
			"|tail -1|awk '{ print "'"$REQUEST"'", $5,"'" $ntimestamp"'"; }'| sed 's/nvalue= /nvalue=/g'>> $QUERYRESULT 
		done )&
		PID=$!
                addPid "Begin Transaction $i" $i $!

	done
	waitPids
else
	cat /dev/null > $QUERYRESULT
	QUERYName=`sed -e '1,4d' $QPREFIX$3.sql` 
	for i in $(seq 1 $2);
	do
		RequestIDX="Request$3"
		REQUEST="$RunName,host=$HOSTNAME,request=$RequestIDX,transaction=$i nvalue="
		ntimestamp=`date +%s%9N`
		sqlcmd -U $LOGIN -P $PASS -d $BASE -S $HOSTNAME -p  -Q "
		BEGIN TRAN T$i;
		SET FMTONLY OFF;
		SET NOCOUNT ON;
		BEGIN
 			$QUERYName
		END
		COMMIT TRAN T$i;
		"|tail -1|awk '{ print "'"$REQUEST"'", $5,"'" $ntimestamp"'"; }'| sed 's/nvalue= /nvalue=/g'>> $QUERYRESULT &
		PID=$!	
		addPid "Begin Transaction $i" $i $!
	done 
 
	waitPids
fi