# install gcc kernel-devel ncurses-devel openssl-devel openssl-devel-engine bc flex bison elfutils-libelf-devel wget xz

VERSION=6.1.21

cd src
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${VERSION}.tar.xz
unxz linux-${VERSION}.tar.xz
tar -xf linux-${VERSION}.tar
cd linux-${VERSION}

cp ../../config/alpine/arm64/config .config

# Включаем VirtIO драйверы
./scripts/config --enable VIRTIO
./scripts/config --enable VIRTIO_PCI
./scripts/config --enable VIRTIO_NET
./scripts/config --enable VIRTIO_CONSOLE

./scripts/config --enable EXT4_FS
./scripts/config --enable OVERLAY_FS

# Мост
./scripts/config --enable BRIDGE
./scripts/config --enable BRIDGE_NETFILTER
./scripts/config --enable IPV6

./scripts/config --enable CONFIG_PACKET
./scripts/config --enable VETH

./scripts/config --disable ARM_SCMI_TRANSPORT_VIRTIO
./scripts/config --disable DEBUG_INFO
./scripts/config --disable DEBUG_INFO_DWARF5

make ARCH=arm64 -j$(nproc) Image.gz

cp arch/arm64/boot/Image.gz ../../kernel/arm64/vmlinuz-${VERSION}
