CREATE USER 'replica'@'%' IDENTIFIED BY 'bench';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%';