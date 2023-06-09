#!/bin/bash

mkdir temp
mount debian* temp
cp -a temp/. iso
chmod -R 644 iso
umount temp

cp preseed.cfg ./iso

sed -i "s+quiet+quiet priority=high file=/cdrom/preseed.cfg+g" iso/isolinux/txt.cfg

xorriso -as mkisofs -o proxmox_custom.iso \
        -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot \
        -boot-load-size 4 -boot-info-table ./iso

isohybrid --uefi ./proxmox_custom.iso
