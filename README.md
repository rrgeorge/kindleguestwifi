# kindleguestwifi
Use a Kindle to display guest wifi access information

You will need to provide a location to host the image used on the kindle to display your guest wifi login information. I generate the image using QREncode and ImageMagick with following commands:

qrencode -m 1 -s 16 -o guestwifiqr.png "WIFI:S:${ssid};T:WPA2;P:${NEWPASS};;"
convert guestwifiqr.png -gravity Center -font CourierNewB -pointsize 40 label:"${ssid}" -pointsize 24 label:"\\nPassword:\\n${NEWPASS}" -gravity Center -append -background white -gravity north -extent 600x800 -type GrayScale -depth 8 -colors 256 guestwifi.png

To use, install the guestwifi script on your Kindle and run it.
