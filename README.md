# kindleguestwifi
Use a Kindle to display guest wifi access information
Requirements:
*A Jailbroken Kindle with usbnetwork and custom screensavers installed
*You will need to provide a location to host the image used on the kindle to display your guest wifi login information. I generate the image using QREncode and ImageMagick with following commands:

`qrencode -m 1 -s 16 -o guestwifiqr.png "WIFI:S:${ssid};T:WPA2;P:${NEWPASS};;"`

`convert guestwifiqr.png -gravity Center -font CourierNewB -pointsize 40 label:"${ssid}" -pointsize 24 label:"\\nPassword:\\n${NEWPASS}" -gravity Center -append -background white -gravity north -extent 600x800 -type GrayScale -depth 8 -colors 256 guestwifi.png`


To install:
1. copy guestwifi.sh script to /mnt/us/scripts/
1. copy guestwifisvc.sh to /usr/local/bin/
1. copy guestwifi.conf to /etc/upstart/
1. edit /usr/share/webkit-1.0/pillow/debug_cmds.json, and add this option:

`";guestwifi" : "/usr/local/bin/guestwifisvc.sh"`
  


Activate by entering `;guestwifi` in the search bar
