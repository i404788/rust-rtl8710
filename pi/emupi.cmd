:: Uncomment to create filesystem
:: goto createfilesys

echo Start emulated Pi.  ssh pi@localhost port 65522.  Redirect host X11 connection to client.
set command="c:\Program Files\qemu\qemu-system-arm"
set fwdssh=hostfwd=tcp::65522-:22
set fwd6000=hostfwd=tcp:127.0.0.1:6000-:6000
set fwd6001=hostfwd=tcp:127.0.0.1:6001-:6001
set fwd6002=hostfwd=tcp:127.0.0.1:6002-:6002
set fwd6003=hostfwd=tcp:127.0.0.1:6003-:6003
set fwd6004=hostfwd=tcp:127.0.0.1:6004-:6004
set fwd6005=hostfwd=tcp:127.0.0.1:6005-:6005
set fwd6006=hostfwd=tcp:127.0.0.1:6006-:6006
set fwd6007=hostfwd=tcp:127.0.0.1:6007-:6007
set fwd6008=hostfwd=tcp:127.0.0.1:6008-:6008
set fwd6009=hostfwd=tcp:127.0.0.1:6009-:6009
set fwd6010=hostfwd=tcp:127.0.0.1:6010-:6010
set fwd6011=hostfwd=tcp:127.0.0.1:6011-:6011
set fwd6012=hostfwd=tcp:127.0.0.1:6012-:6012
set fwd6013=hostfwd=tcp:127.0.0.1:6013-:6013
set fwd6014=hostfwd=tcp:127.0.0.1:6014-:6014
set fwd6015=hostfwd=tcp:127.0.0.1:6015-:6015
set fwd6016=hostfwd=tcp:127.0.0.1:6016-:6016
set fwd6017=hostfwd=tcp:127.0.0.1:6017-:6017
set fwd6018=hostfwd=tcp:127.0.0.1:6018-:6018
set fwd6019=hostfwd=tcp:127.0.0.1:6019-:6019

set fwd6000=guestfwd=tcp:127.0.0.1:6000-tcp:192.168.1.177:6000
set fwd6001=guestfwd=tcp:127.0.0.1:6001-tcp:192.168.1.177:6001
set fwd6002=guestfwd=tcp:127.0.0.1:6002-tcp:192.168.1.177:6002
set fwd6003=guestfwd=tcp:127.0.0.1:6003-tcp:192.168.1.177:6003
set fwd6004=guestfwd=tcp:127.0.0.1:6004-tcp:192.168.1.177:6004
set fwd6005=guestfwd=tcp:127.0.0.1:6005-tcp:192.168.1.177:6005
set fwd6006=guestfwd=tcp:127.0.0.1:6006-tcp:192.168.1.177:6006
set fwd6007=guestfwd=tcp:127.0.0.1:6007-tcp:192.168.1.177:6007
set fwd6008=guestfwd=tcp:127.0.0.1:6008-tcp:192.168.1.177:6008
set fwd6009=guestfwd=tcp:127.0.0.1:6009-tcp:192.168.1.177:6009
set fwd6010=guestfwd=tcp:127.0.0.1:6010-tcp:192.168.1.177:6010
set fwd6011=guestfwd=tcp:127.0.0.1:6011-tcp:192.168.1.177:6011
set fwd6012=guestfwd=tcp:127.0.0.1:6012-tcp:192.168.1.177:6012
set fwd6013=guestfwd=tcp:127.0.0.1:6013-tcp:192.168.1.177:6013
set fwd6014=guestfwd=tcp:127.0.0.1:6014-tcp:192.168.1.177:6014
set fwd6015=guestfwd=tcp:127.0.0.1:6015-tcp:192.168.1.177:6015
set fwd6016=guestfwd=tcp:127.0.0.1:6016-tcp:192.168.1.177:6016
set fwd6017=guestfwd=tcp:127.0.0.1:6017-tcp:192.168.1.177:6017
set fwd6018=guestfwd=tcp:127.0.0.1:6018-tcp:192.168.1.177:6018
set fwd6019=guestfwd=tcp:127.0.0.1:6019-tcp:192.168.1.177:6019

:: set netpara=-net nic -nic user,%fwdssh%,%fwd6000%,%fwd6001%,%fwd6002%,%fwd6003%,%fwd6004%,%fwd6005%,%fwd6006%,%fwd6007%,%fwd6008%,%fwd6009%,%fwd6010%,%fwd6011%,%fwd6012%,%fwd6013%,%fwd6014%,%fwd6015%,%fwd6016%,%fwd6017%,%fwd6018%,%fwd6019%
set netpara=-net nic -nic user,%fwdssh%

:: -net tap,ifname=TAP32,script=no,downscript=no
set paras=-kernel "C:\Pi\kernel-qemu-4.9.59-stretch_with_VirtFS" -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda "c:\pi\raspbian-stretch.qcow" -cpu arm1176 -m 256 -M versatilepb -dtb "c:\pi\versatile-pb.dtb" -no-reboot -serial stdio %netpara%
%command% %paras%
goto end

:createfilesys
echo Create Pi filesystem
pause
del "c:\pi\raspbian-stretch.qcow"
"c:\Program Files\qemu\qemu-img" convert -f raw -O qcow2 "c:\2018-04-18-raspbian-stretch.img" "c:\pi\raspbian-stretch.qcow"
"c:\Program Files\qemu\qemu-img" resize "c:\pi\raspbian-stretch.qcow" +11G
"c:\Program Files\qemu\qemu-img" info "c:\pi\raspbian-stretch.qcow"
:end
