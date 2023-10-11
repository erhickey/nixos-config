# Unencrypted File System

Partitioning:
- Create GPT partition table
- Create boot partition: type `EFI System`
- Swap partition: type `Linux swap`
- Other partitions: types `Linux root` (by arch), `Linux home`, `Linux filesystem`, etc

Format:
```bash
mkfs.fat -F 32 -n boot /dev/sda1
mkswap -L swap /dev/sda2
mkfs.ext4 -L nixos /dev/sda3
```

Mount partitions:
```bash
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
```
