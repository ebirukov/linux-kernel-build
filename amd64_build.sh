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

./scripts/config --enable EXT4_FS
./scripts/config --enable CONFIG_OVERLAY_FS

echo "CONFIG_DEBUG_INFO_NONE=y" >> .config
echo "# CONFIG_DEBUG_INFO is not set" >> .config
echo "# CONFIG_DEBUG_INFO_DWARF5 is not set" >> .config

make ARCH=x86 -j$(nproc) bzImage
cp arch/x86/boot/bzImage ../../amd64/vmlinuz-${VERSION}
