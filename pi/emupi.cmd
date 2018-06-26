:: Uncomment to create filesystem
:: goto createfilesys

echo Start emulated Pi.  Redirect incoming ssh from port 65522 of the local PC.
set command="c:\Program Files\qemu\qemu-system-arm"
set fwdssh=hostfwd=tcp::65522-:22
set netpara=-net nic -nic user,%fwdssh%
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
