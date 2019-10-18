#!/bin/bash
OP=${1}
HOST=${2}
PORT=${3}
TPCC_DIR=${4}
DB='sbtpcc'
USER='root'
PASS='bench'

if [ $OP == 'prepare' ];
then
        # Cria estrutura do BD
        mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "create database sbtpcc"
        #mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} tpcc < $TPCC_DIR/create_table.sql
        #mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} tpcc < $TPCC_DIR/add_fkey_idx.sql

        ./sysbench-tpcc/tpcc.lua --mysql-socket=${HOST} --mysql-user=${USER} --mysql-db=${DB} --time=300 --threads=4 --report-interval=1 --tables=1 --scale=1 --db-driver=mysql prepare
elif [ $OP == 'execute' ]
then
        #tpcc_start -h${HOST} -P${PORT} -d${DB} -u${USER} -p${PASS} -w1 -c32 -r10 -l300
        ./tpcc.lua --mysql-socket=${HOST} --mysql-user=${USER} --mysql-db=${DB} --time=300 --threads=4 --report-interval=1 --tables=1 --scale=1 --db-driver=mysql run
fi