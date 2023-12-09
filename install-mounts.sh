mount -o subvol=root,compress=zstd,noatime /dev/data/root /mnt

mount -o subvol=home,compress=zstd,noatime /dev/data/root /mnt/home

mount -o subvol=nix,compress=zstd,noatime /dev/data/root /mnt/nix

mount -o subvol=persist,compress=zstd,noatime /dev/data/root /mnt/persist

mount -o subvol=log,compress=zstd,noatime /dev/data/root /mnt/var/log

# don't forget this!
mount /dev/nvme0n1p1 /mnt/boot
