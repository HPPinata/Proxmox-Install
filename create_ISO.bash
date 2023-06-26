#!/bin/bash

mkdir temp
mount debian* temp
cp -a temp/. iso
chmod -R 644 iso
umount temp

cp preseed.cfg ./iso

sed -i "s+quiet+quiet priority=high locale=en_US.UTF-8 keymap=de file=/cdrom/preseed.cfg+g" iso/isolinux/txt.cfg iso/boot/grub/grub.cfg

OUTPUT=proxmox_custom.iso
xorrisofs \
   -r -V "Proxmox Autoinstall" \
   -o "$OUTPUT" \
   -J -J -joliet-long -cache-inodes \
   -b isolinux/isolinux.bin \
   -c isolinux/boot.cat \
   -boot-load-size 4 -boot-info-table -no-emul-boot \
   -eltorito-alt-boot \
   -e boot/grub/efi.img \
   -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
   ./iso
    
isohybrid --uefi $OUTPUT
