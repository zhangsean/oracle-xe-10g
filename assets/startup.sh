#!/bin/bash
sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/listener.ora;
sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" $ORACLE_HOME/network/admin/tnsnames.ora;

service oracle-xe start

if [ "$ORACLE_ALLOW_REMOTE" = true ]; then
  echo "alter system disable restricted session;" | sqlplus -s SYSTEM/oracle
fi

for f in /docker-entrypoint-initdb.d/*; do
  case "$f" in
    *.sh)     echo "$0: running $f"; . "$f" ;;
    *.sql)    echo "$0: running $f"; echo "exit" | sqlplus SYS/oracle as SYSDBA @"$f"; echo ;;
    *)        echo "$0: ignoring $f" ;;
  esac
  echo
done
