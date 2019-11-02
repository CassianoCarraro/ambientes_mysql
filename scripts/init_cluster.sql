UPDATE mysql.user SET Host="%" WHERE User="root";
FLUSH PRIVILEGES;