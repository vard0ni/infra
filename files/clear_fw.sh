#/bin/bash
## Очистка firewall

# Очистка всех правил в таблицах iptables
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -t raw -F

# Удаление всех пользовательских цепочек в таблицах
iptables -X                
iptables -t nat -X         
iptables -t mangle -X          
iptables -t raw -X          