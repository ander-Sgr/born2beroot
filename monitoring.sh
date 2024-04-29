#infor kernal and SO
info_kernel=$(uname -a)

#physical
physical_processors=$(grep "physical id" /proc/cpuinfo | wc -l)

#virtual
virtual_processors=$(grep "processor" /proc/cpuinfo | wc -l)


#RAM TOTAL NR -> condicion que solo aplica a la linea 2
ram_usage=$(free --mega | awk 'NR==2 {print $3 "/" $2 "MB (" sprintf("%.2f", $3/$2*100)"%)"}')

#DISK usage
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{total += $2} END {printf ("%.1fGb\n"), total/1024}')
disk_usage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used += $3} END {print used}')
disk_percentage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{used += $3} {total += $2} END {printf("%d"), used/total*100}')

#CPU LOAD:
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_used=$(expr 100 - $cpu_load)
cpu_resume=$(printf "%.1f" $cpu_used)

#last date & time boot
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#LVM enable ?
lvm_enable=$(if [ -d "/etc/lvm" ]; then echo yes; else echo no; fi)

#NUM CONNECTIONS ACTIVES
num_connections=$(ss -ta | grep ESTAB | wc -l)

#NUM USER LOG
num_log_users=$(users | wc -l)

#NETWORK IP
ip_addr=$(hostname -I)
mac_addr=$(ip a | grep link/ether | awk '{print $2}')

#number of commands executes with sudo
num_commands=$(journalctl _COMM=sudo  -q | grep COMMAND | wc -l)

wall "  Architecture: $info_kernel
        CPU physical: $physical_processors
        vCPU: $virtual_processors
        Memory Usage: $ram_usage
        Disk Usage: $disk_usage/$disk_total ($disk_percentage%)
        Cpu load: $cpu_resume%
        Last boot: $last_boot
        LVM use: $lvm_enable
        TCP Connections : $num_connections ESTABLISHED
        User log: $num_log_users
        Network: IP $ip_addr($mac_addr)
        Sudo: $num_commands cmd"