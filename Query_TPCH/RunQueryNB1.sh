#!/bin/bash

# 
#  
#
#  @project     PerfmonSQL
#  @package     RunQuery Test
#  @subpackage
#  @access      tpch
#  @paramtype   Login : [sa] Password :[] DataBase : [TPCH] HOSTNAME : [SQL Server ip Address]
#  @argument    Run Name :[String without space] - Iteration Number : vUsers - Query Number [Query 1 to 22 - 0 for all Query in synchronous mode ]
#  @description Run TPC-H Query 1 to 9
#
#  @author Emmanuel COLUSSI
#  @version 1.00
#  @Copyright 2017 Hewlett Packard Enterprise
#  @test    http://localhost:3008
# 
# 


LOGIN="sa"
PASS="Bench123"
BASE="tpch300g"
HOSTNAME="10.6.29.80"
QPREFIX="QDB_Query_"
QUERYRESULT="ResultQuery$3.txt"

declare -A transs

for nrq in $(seq 1 9);
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
			COMMIT TRAN T$nrq;
			"|tail -1|awk '{print $5}'|curl -i -XPOST "http://10.6.29.3:8086/write?db=perfmon"  --data-binary "TPCHQ,request=Q$nrq,host=DL35 value=$(cat)"
		done 
		

done