#!/usr/bin/bash

# Define the clock
Clock() {
        DATETIME=$(date "+%a %b %d \ue015 %R")
        echo -e "$DATETIME"
}

#Define the battery
Battery() {
	# Get charger info
	CHARGER=$(acpi --ac-adapter)
	if [ "$CHARGER" = "Adapter 0: on-line" ]; then
		 C_ICON="\ue20e"
	else
		C_ICON="\ue20f"
	fi
	# Get battery info
        BATPERC=$(acpi --battery | cut -d, -f2)
	BATINT=${BATPERC::-1}
	BAT_COL=""
	BAT_ICON=""
	if [ $BATINT -gt 75 ]; then
		BAT_COL="#98971a"
		BAT_ICON="\ue214"
	elif [ $BATINT -gt 50 ]; then
		BAT_COL="#fabd2f"
		BAT_ICON="\ue213"
	elif [ $BATINT -gt 25 ]; then
		BAT_COL="#b16286"
		BAT_ICON="\ue212"
	else
		BAT_COL="#cc241d"
		BAT_ICON="\ue211"
	fi
        echo -e "$BAT_ICON$C_ICON%{F$BAT_COL}$BATPERC%{F-}"
}

#Define disc stats
Disk() {
	ArchS="\ue1f0"
	ShareS="\ue1bb"
	ArchD="$(df -h --output=pcent '/dev/sdb3' | tail -n 1)"
	ShareD="$(df -h --output=pcent '/dev/sda1' | tail -n 1)"
	echo -e "$ArchS$ArchD $ShareS$ShareD"
}

#Define network status
Network() {
	CONNECTION="\ue048 $(nmcli -t connection show --active | cut --fields=1 --delimiter=':' | tail -n1)"
	STATUS="$(nmcli networking connectivity)"
	VPN_CON="$(ip a | grep 'mullvad' | cut --fields=2 --delimiter=' ' | cut --fields=1 --delimiter=$'\n')"
	STAT_COL=""
	CON_STAT="$(nmcli -t general status | cut --fields=1 --delimiter=':')"
	if [ "$STATUS" = "full"  ]; then
		STAT_COL="#98971a"
	elif [ "$STATUS" = "limited" ]; then
		STAT_COL="#fabd2f"
	elif [ "$STATUS" = "none" ]; then
		STAT_COL="#cc241d"
	else
		STAT_COL="#b16286"
	fi
	if [ "$CON_STAT" != "connecting" ]; then
		CON_STAT=""	
	fi
	echo -e "$CONNECTION [$VPN_CON] %{F$STAT_COL}$STATUS $CON_STAT%{F-}"
}

#Define the workspace display
WorkSpace() {
	WSPACE=$(xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //')
	NUMSEL=""
	if [ "$WSPACE" = "0" ]; then
		NUMSEL="%{B#333333}%{+o}1%{-o}%{B-} 2 3 4 5 6 7 8 9 0"
	elif [ "$WSPACE" = "1" ]; then 
		NUMSEL="1 %{B#333333}%{+o}2%{-o}%{B-} 3 4 5 6 7 8 9 0"
	elif [ "$WSPACE" = "2" ]; then 
		NUMSEL="1 2 %{B#333333}%{+o}3%{-o}%{B-} 4 5 6 7 8 9 0"
	elif [ "$WSPACE" = "3" ]; then 
		NUMSEL="1 2 3 %{B#333333}%{+o}4%{-o}%{B-} 5 6 7 8 9 0"
	elif [ "$WSPACE" = "4" ]; then
		NUMSEL="1 2 3 4 %{B#333333}%{+o}5%{-o}%{B-} 6 7 8 9 0"
	elif [ "$WSPACE" = "5" ]; then 
		NUMSEL="1 2 3 4 5 %{B#333333}%{+o}6%{-o}%{B-} 7 8 9 0"
	elif [ "$WSPACE" = "6" ]; then
		NUMSEL="1 2 3 4 5 6 %{B#333333}%{+o}7%{-o}%{B-} 8 9 0"
	elif [ "$WSPACE" = "7" ]; then 
		NUMSEL="1 2 3 4 5 6 7 %{B#333333}%{+o}8%{-o}%{B-} 9 0"
	elif [ "$WSPACE" = "8" ]; then
		NUMSEL="1 2 3 4 5 6 7 8 %{B#333333}%{+o}9%{-o}%{B-} 0"
	elif [ "$WSPACE" = "9" ]; then
		NUMSEL="1 2 3 4 5 6 7 8 9 %{B#333333}%{+o}0%{-o}%{B-}"
	fi
	echo "%{U#999999}$NUMSEL%{U-}"
}

#Get volume information
Volume() {
	MUTESTATE=$(pactl list sinks | grep "Mute:")
	if [ "$MUTESTATE" = "	Mute: no" ]; then
		V_SYMBOL="\ue050"
	else
		V_SYMBOL="\ue04f"
	fi
	V_PERCENT=$(pactl list sinks | grep "Volume" | cut -d " " -f 6 | cut -d $'\n' -f 1 )
	echo -e "%{T2}$V_SYMBOL%{T-} $V_PERCENT"
}

#SLOWSTUFF=""
#while :; do echo -e "%{r}  $(Disk) | $(Clock) | $(Battery)"; sleep 30; done > $SLOWSTUFF & 
#while :; do echo -e "%{l} \ue0dd $(WorkSpace) $(Volume) %{c} $(Network)  $SLOWSTUFF"; sleep 1; done &

declare -i COUNTER=60
while true; do
	if ((COUNTER=60)); then 
		SLOWSTUFF="%{r}  $(Disk) | $(Clock) | $(Battery)"
		COUNTER=0 
	fi
        echo -e "%{l} \ue0dd $(WorkSpace) | $(Volume) %{c} $(Network)  $SLOWSTUFF"
        ((COUNTER=COUNTER+1))
	sleep 1s
done

