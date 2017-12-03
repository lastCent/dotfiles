#!/usr/bin/bash

# Define the clock
Clock() {
        DATETIME=$(date "+%a %b %d, %R")
        echo -n "$DATETIME"
}

#Define the battery
Battery() {
        BATPERC=$(acpi --battery | cut -d, -f2)
	BATINT=${BATPERC::-1}
	BAT_COL=""
	if [ $BATINT -gt 75 ]; then
		BAT_COL="#98971a"
	elif [ $BATINT -gt 50 ]; then
		BAT_COL="#fabd2f"
	elif [ $BATINT -gt 25 ]; then
		BAT_COL="#b16286"
	else
		BAT_COL="#cc241d"
	fi
        echo "Battery:%{F$BAT_COL}$BATPERC%{F-}"
}

#Define disc stats
Disk() {
	ArchD="Main: $(df -h -P | grep /dev/sdb3 | cut --fields=16 --delimiter=' ')"
	ShareD="Share: $(df -h -P | grep /dev/sda1 | cut --fields=15 --delimiter=' ')"
	echo "$ArchD $ShareD"
}

#Define network status
Network() {
	CONNECTION="Wifi: $(nmcli -t connection show --active | cut --fields=1 --delimiter=':')"
	STATUS="$(nmcli networking connectivity)"
	STAT_COL=""
	if [ "$STATUS" = "full"  ]; then
		STAT_COL="#98971a"
	elif [ "$STATUS" = "limited" ]; then
		STAT_COL="#fabd2f"
	elif [ "$STATUS" = "none" ]; then
		STAT_COL="#cc241d"
	else
		STAT_COL="#b16286"
	fi
	echo "$CONNECTION %{F$STAT_COL}$STATUS%{F-}"
}

#Define the workspace display
WorkSpace() {
	WSPACE=$(xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //')
	if [ "$WSPACE" = "0" ]; then
		echo "%{B#cc241d}1%{B-} 2 3 4 5 6 7 8 9 0"
	elif [ "$WSPACE" = "1" ]; then 
		echo "1 %{B#cc241d}2%{B-} 3 4 5 6 7 8 9 0"
	elif [ "$WSPACE" = "2" ]; then 
		echo "1 2 %{B#cc241d}3%{B-} 4 5 6 7 8 9 0"
	elif [ "$WSPACE" = "3" ]; then 
		echo "1 2 3 %{B#cc241d}4%{B-} 5 6 7 8 9 0"
	elif [ "$WSPACE" = "4" ]; then
		echo "1 2 3 4 %{B#cc241d}5%{B-} 6 7 8 9 0"
	elif [ "$WSPACE" = "5" ]; then 
		echo "1 2 3 4 5 %{B#cc241d}6%{B-} 7 8 9 0"
	elif [ "$WSPACE" = "6" ]; then
		echo "1 2 3 4 5 6 %{B#cc241d}7%{B-} 8 9 0"
	elif [ "$WSPACE" = "7" ]; then 
		echo "1 2 3 4 5 6 7 %{B#cc241d}8%{B-} 9 0"
	elif [ "$WSPACE" = "8" ]; then
		echo "1 2 3 4 5 6 7 8 %{B#cc241d}9%{B-} 0"
	elif [ "$WSPACE" = "9" ]; then
		echo "1 2 3 4 5 6 7 8 9 %{B#cc241d}0%{B-}"
	fi
}

declare -i COUNTER=60
while true; do
	if ((COUNTER=60)); then 
		SLOWSTUFF="%{r}  $(Disk) | $(Clock) | $(Battery)"
		COUNTER=0 
	fi
        echo "%{l} $(WorkSpace) %{c} $(Network)  $SLOWSTUFF"
        ((COUNTER=COUNTER+1))
	sleep 1s
	#TODO: add state (connecting)
done

