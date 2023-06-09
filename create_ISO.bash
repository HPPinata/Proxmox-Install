#!/bin/bash

mkdir temp
mount debian* temp
cp -a temp/. iso
chmod -R 644 iso
umount temp

cp preseed.cfg ./iso

sed -i "s+quiet+quiet priority=high file=/cdrom/preseed.cfg+g" iso/isolinux/txt.cfg

OUTPUT=proxmox_custom.iso
VERSION=7.4
xorrisofs -o $OUTPUT -v -r -J --joliet-long -V "Proxmox $VERSION" -c isolinux/boot.cat -b isolinux/isolinux.bin \
          -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efiboot.img -no-emul-boot .

isohybrid --uefi $OUTPUT
