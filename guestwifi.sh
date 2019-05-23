#!/bin/sh
FIRSTSTART=1
SUSPENDFOR=14400
DOWNLOADURL="http://example.com/wifi.png"
RTCDEV=rtc1
SHOWBATT=1

wait_wlan() {
	return `lipc-get-prop com.lab126.wifid cmState | grep CONNECTED | wc -l`
}
echo $$ > /var/run/guestwifi.pid

echo "Starting Guest Wifi Script..."
date
echo "Setting CPU to powersave"
echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "Disabling Screensaver"
lipc-set-prop com.lab126.powerd preventScreenSaver 1
if [ ${FIRSTSTART} -eq 1 ]
then
	#wait a minute before sleeping the first time 
	echo "First run, waiting a minute..."
	sleep 60
else
	eips -f -g /mnt/base-us/screensaver/bg_xsmall_ss00.png
fi
while true; do

if [ -e /mnt/us/screensaver/bg_xsmall_ss00.png ] && [ $(( `date +%s` - `stat -c '%Y' /mnt/us/screensaver/bg_xsmall_ss00.png` )) -lt 3600 ]
then
	echo "Settings have been updated recently, doing nothing."
else

WIRELESSSTATE=`lipc-get-prop com.lab126.cmd wirelessEnable`

 if [ ${WIRELESSSTATE} -eq 0 ]
 then
  echo "Turning on Wireless"
  lipc-set-prop com.lab126.cmd wirelessEnable 1
 fi

 WLANNOTCONNECTED=0
 WLANCOUNTER=0


 echo "Waiting for WiFi..."
 while wait_wlan; do
	if [ ${WLANCOUNTER} -gt 60 ]
	then
		WLANNOTCONNECTED=1
		break
	fi
	let WLANCOUNTER=WLANCOUNTER+1
	sleep 1
 done


 if [ ${WLANNOTCONNECTED} -eq 0 ]
 then
	echo "Downloading new IMG"
	wget -qO /mnt/base-us/screensaver/bg_xsmall_ss00.png ${DOWNLOADURL}
 else
	echo "No WiFi... Skipping this update..."
 fi

 if [ ${WIRELESSSTATE} -eq 0 ]
 then
  echo "Turning off Wireless"
  lipc-set-prop com.lab126.cmd wirelessEnable 0
  sleep 1
 fi

fi

PIDMTIME=$(( `date +%s` - `stat -c '%Y' /var/run/guestwifi.pid` ))

if [ ${FIRSTSTART} -eq 1 ] || [ ${PIDMTIME} -gt ${SUSPENDFOR} ]
then
	FIRSTSTART=0

	touch /var/run/guestwifi.pid

	eips -f -g /mnt/base-us/screensaver/bg_xsmall_ss00.png

	BATTLEVEL=$(gasgauge-info -c|sed -e 's/%//')

	if [ ${BATTLEVEL} -lt 10 ]
	then
		eips -x 0 -y 39 "Low Battery"
	elif [ ${BATTLEVEL} -eq 100 ]
	then
		eips -x 0 -y 39 "Battery Full"
	fi
	if [ ${SHOWBATT} -eq 1 ]
	then
		eips -x 0 -y 39 "$(printf '%50.50s' ${BATTLEVEL})"
	fi
	sleep 1
	rtcwake -d ${RTCDEV} -m mem -s ${SUSPENDFOR}
 else
 	echo "Was asleep only ${PIDMTIME} seconds, sleeping for 5 minutes."

	sleep 300
fi

done
