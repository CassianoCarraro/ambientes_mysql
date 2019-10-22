#!/bin/bash
OP=${1}
HOST=${2}
PORT=${3}
NAME=${4}
SCALE=${5}
THREADS=${6}

DB='sb'
USER='test'
PASS='asdf0000'
TPCC_DIR='./tpcc-mysql'
PREPARE_OUT=~/benchsres/bench_prepare_${NAME}_${SCALE}_$(date +%d%m%H%M
).out
EXECUTE_OUT=~/benchsres/bench_run_${NAME}_${SCALE}_${THREADS}_$(date +%d%m%H%M
).out
EXECUTE_TIME=300

[[ -d ~/benchsres ]] || mkdir ~/benchsres

if [ $OP == 'prepare' ];
then
        mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "create database if not exists ${DB}"
        echo "Executando o prepare"

        mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} ${DB} < $TPCC_DIR/create_table.sql
        mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} ${DB} < $TPCC_DIR/add_fkey_idx.sql

        $TPCC_DIR/tpcc_load \
            -h${HOST} \
            -P${PORT} \
            -d${DB} \
            -u${USER} \
            -p${PASS} \
            -w${SCALE} &> "$PREPARE_OUT"

elif [ $OP == 'run' ]
then
        echo "Executando o bench"
        $TPCC_DIR/tpcc_start \
            -h${HOST} \
            -P${PORT} \
            -d${DB} \
            -u${USER} \
            -p${PASS} \
            -w${SCALE} \
            -c${THREADS} \
            -r30 \
            -l${EXECUTE_TIME} &> "$EXECUTE_OUT"

elif [ $OP == 'clean' ]
then
    mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "drop database ${DB}"
else
    echo "Operação inválida!"
fi