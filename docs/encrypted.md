# Encrypted File System

Partitioning:
- Create GPT partition table
- Create boot partition: type `EFI System`
- Create lvm partition: type `Linux LVM`
- Setup encrypted partition and create logical volumes:
```bash
cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 enc-pv
pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L 8G -n swap vg
lvcreate -l '100%FREE' -n nixos vg
```

Format:
```bash
mkfs.fat -F 32 -n boot /dev/sda1
mkswap -L swap /dev/vg/swap
mkfs.ext4 -L nixos /dev/vg/nixos
```

Mount partitions:
```bash
mount /dev/vg/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vg/swap
```
