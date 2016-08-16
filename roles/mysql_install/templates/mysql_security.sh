#!/bin/bash
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "grant all privileges on *.* to {{ mysql_database_user }}@'{{ ansible_default_ipv4.address }}' identified by '{{ mysql_passwd }}' with grant option;"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "grant PROCESS,REPLICATION CLIENT ON *.* TO 'zabbix'@'%' identified BY 'zabbix';"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "grant ALL PRIVILEGES ON *.* TO 'wxf'@'%' identified BY 'wxf';"

{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "drop database test;"
# {{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "update mysql.user set password=password('{{ mysql_passwd }}') where user='{{ mysql_database_user }}' and host='localhost';"
if test -f {{ mysql_basedir }}/scripts/mysql_install_db ; then
  echo MySQL5.6
  {{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "update mysql.user set password=password('{{ mysql_passwd }}') where user='{{ mysql_database_user }}' and host='localhost';"
else
  echo MySQL5.7.14
  {{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "update mysql.user set authentication_string=password('{{ mysql_passwd }}') where user='{{ mysql_database_user }}' and host='localhost';"
fi

{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "delete from mysql.user where password='';"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "flush privileges;"


