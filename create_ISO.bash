#!/bin/bash

mkdir temp
mount debian* temp
cp -a temp/. iso
chmod -R 644 iso
umount temp

cp preseed.cfg ./iso

sed -i "s+quiet+quiet priority=high locale=en_US.UTF-8 keymap=de file=/cdrom/preseed.cfg+g" iso/isolinux/txt.cfg iso/boot/grub/grub.cfg

OUTPUT=proxmox_custom.iso
xorriso \
   -outdev "$OUTPUT" \
   -volid "$OUTPUT" \
   -padding 0 \
   -compliance no_emul_toc \
   -map "./iso" / \
   -chmod 0755 / -- \
   -boot_image isolinux dir=/isolinux \
   -boot_image any next \
   -boot_image any efi_path=boot/grub/efi.img \
   -boot_image isolinux partition_entry=gpt_basdat \
   -stdio_sync off

isohybrid --uefi $OUTPUT
