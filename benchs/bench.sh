#!/bin/bash
BENCH=${1}
OP=${2}
HOST=${3}
PORT=${4}
NAME=${5}
SCALE=${6}
THREADS=${7}

DB='sb'
USER='root'
PASS='bench'
TPCC_DIR='./tpcc-mysql'
PREPARE_OUT=~/benchsres/bench_prepare_${BENCH}_${NAME}_${SCALE}_$(date +%d%m%H%M
).out
EXECUTE_OUT=~/benchsres/bench_run_${BENCH}_${NAME}_${SCALE}_${THREADS}_$(date +%d%m%H%M
).out
EXECUTE_TIME=300

[[ -d ~/benchsres ]] || mkdir ~/benchsres

if [ $OP == 'prepare' ];
then
        mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "create database if not exists ${DB}"
        echo "Executando o prepare"

        if [ $BENCH == 'TPCC' ];
        then
            mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} ${DB} < $TPCC_DIR/create_table.sql
            mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} ${DB} < $TPCC_DIR/add_fkey_idx.sql

            $TPCC_DIR/tpcc_load \
                -h${HOST} \
                -P${PORT} \
                -d${DB} \
                -u${USER} \
                -p${PASS} \
                -w${SCALE} &> "$PREPARE_OUT"
        elif [ $BENCH == 'SB' ]
        then
            sysbench \
            --mysql-host=${HOST} \
            --mysql-port=${PORT} \
            --mysql-user=${USER} \
            --mysql-password=${PASS} \
            --mysql-db=${DB} \
            --db-driver="mysql" \
            --threads=4 \
            --tables=10 \
            --table-size=${SCALE} \
            oltp_read_only prepare &> "$PREPARE_OUT"
        else
            echo "Operação inválida!"
        fi

elif [ $OP == 'run' ]
then
        echo "Executando o bench"

        if [ $BENCH == 'TPCC' ];
        then
            $TPCC_DIR/tpcc_start \
                -h${HOST} \
                -P${PORT} \
                -d${DB} \
                -u${USER} \
                -p${PASS} \
                -w${SCALE} \
                -c${THREADS} \
                -r10 \
                -l${EXECUTE_TIME} &> "$EXECUTE_OUT"
        elif [ $BENCH == 'SB' ]
        then
            sysbench \
            --mysql-host=${HOST} \
            --mysql-port=${PORT} \
            --mysql-user=${USER} \
            --mysql-password=${PASS} \
            --mysql-db=${DB} \
            --db-driver="mysql" \
            --threads=${THREADS} \
            --tables=10 \
            --table-size=${SCALE} \
            --time=${EXECUTE_TIME} \
            --report-interval=10 \
            oltp_read_only run &> "$EXECUTE_OUT"
        else
            echo "Operação inválida!"
        fi

elif [ $OP == 'clean' ]
then
    mysql -u${USER} -p${PASS} -h${HOST} -P${PORT} -e "drop database ${DB}"
else
    echo "Operação inválida!"
fi