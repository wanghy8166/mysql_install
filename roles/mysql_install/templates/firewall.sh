iptables -A INPUT -p tcp --dport {{ mysql_port }} -j ACCEPT
iptables -A OUTPUT -p tcp --sport {{ mysql_port }} -j ACCEPT
service iptables save
service iptables restart
