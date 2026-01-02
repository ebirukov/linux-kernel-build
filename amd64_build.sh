VERSION=6.1.21

cd src
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${VERSION}.tar.xz
unxz linux-${VERSION}.tar.xz
tar -xvf linux-${VERSION}.tar
cd linux-${VERSION}

cp ../../config/alpine/amd64/config .config

# Включаем VirtIO драйверы
./scripts/config --enable VIRTIO
./scripts/config --enable VIRTIO_PCI
./scripts/config --enable VIRTIO_NET
./scripts/config --enable VIRTIO_CONSOLE

./scripts/config --enable VIRTIO_9P
./scripts/config --enable 9P_FS
./scripts/config --enable NET_9P
./scripts/config --enable NET_9P_VIRTIO


./scripts/config --enable EXT4_FS
./scripts/config --enable OVERLAY_FS

# Мост
./scripts/config --enable BRIDGE
./scripts/config --enable BRIDGE_NETFILTER
./scripts/config --enable IPV6

./scripts/config --enable VETH

./scripts/config --enable DEBUG_INFO_NONE

echo "# DEBUG_INFO is not set" >> .config
echo "# DEBUG_INFO_DWARF5 is not set" >> .config

make ARCH=x86 -j$(nproc) bzImage
cp arch/x86/boot/bzImage ../../kernel/amd64/vmlinuz-${VERSION}
