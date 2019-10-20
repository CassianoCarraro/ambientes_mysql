#!/bin/bash
OP=${1}
HOST=${2}
PORT=${3}
NAME=${4}
SCALE=${5}
THREADS=${6}

DB='sb'
USER='root'
PASS='bench'
PREPARE_OUT=~/benchsres/bench_prepare_${NAME}_${SCALE}_$(date +%d%m%H%M
).out
EXECUTE_OUT=~/benchsres/bench_run_${NAME}_${SCALE}_${THREADS}_$(date +%d%m%H%M
).out

[[ -d ~/benchsres ]] || mkdir ~/benchsres

if [ $OP == 'prepare' ];
then
        mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "create database if not exists ${DB}"
        echo "Iniciando o prepare"
        ./tpcc.lua \
            --mysql-host=${HOST} \
            --mysql-port=${PORT} \
            --mysql-user=${USER} \
            --mysql-password=${PASS} \
            --mysql-db=${DB} \
            --time=300 \
            --threads=4 \
            --report-interval=10 \
            --tables=1 \
            --scale=${SCALE} \
            --db-driver=mysql prepare &> "$PREPARE_OUT"

elif [ $OP == 'run' ]
then
        echo "Iniciando o run"
        ./tpcc.lua \
            --mysql-host=${HOST} \
            --mysql-port=${PORT} \
            --mysql-user=${USER} \
            --mysql-password=${PASS} \
            --mysql-db=${DB} \
            --time=30 \
            --threads=${THREADS} \
            --report-interval=10 \
            --tables=1 \
            --scale=${SCALE} \
            --db-driver=mysql run &> "$EXECUTE_OUT"

elif [ $OP == 'clean' ]
then
    mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "drop database ${DB}"
else
    echo "Operação inválida!"
fi