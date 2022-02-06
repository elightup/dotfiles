#!/bin/bash

###############################################################################
# Display server info
#
# Modified from tocdo.net script
###############################################################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'

get_opsy() {
	[ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
	[ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
	printf "%-70s\n" "-" | sed 's/\s/-/g'
}

calc_disk() {
	local total_size=0
	local array=$@
	for size in ${array[@]}
	do
		[ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
		[ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
		[ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
		[ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
		total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
	done
	echo ${total_size}
}

test() {
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	tram=$( free -m | awk '/Mem/ {print $2}' )
	uram=$( free -m | awk '/Mem/ {print $3}' )
	swap=$( free -m | awk '/Swap/ {print $2}' )
	uswap=$( free -m | awk '/Swap/ {print $3}' )
	up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days, %d hour %d min\n",a,b,c)}' /proc/uptime )
	load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	opsy=$( get_opsy )
	arch=$( uname -m )
	lbit=$( getconf LONG_BIT )
	kern=$( uname -r )
	date=$( date )
	disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
	disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
	disk_total_size=$( calc_disk ${disk_size1[@]} )
	disk_used_size=$( calc_disk ${disk_size2[@]} )

	echo "System Info"
	next
	echo "CPU model            : $cname"
	echo "Number of cores      : $cores"
	echo "CPU frequency        : $freq MHz"
	echo "Total size of Disk   : $disk_total_size GB ($disk_used_size GB Used)"
	echo "Total amount of Mem  : $tram MB ($uram MB Used)"
	echo "Total amount of Swap : $swap MB ($uswap MB Used)"
	echo "System uptime        : $up"
	echo "Load average         : $load"
	echo "OS                   : $opsy"
	echo "Arch                 : $arch ($lbit Bit)"
	echo "Kernel               : $kern"
	echo "Virt                 : $virt"
	echo "Date                 : $date"
	next
}
clear
test