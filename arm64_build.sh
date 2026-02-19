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
./scripts/config --enable RTC_DRV_PL031

./scripts/config --enable VIRTIO_BLK
./scripts/config --enable VIRTIO_MMIO

./scripts/config --enable EXT4_FS
./scripts/config --enable OVERLAY_FS

# Мост
./scripts/config --enable BRIDGE
./scripts/config --enable BRIDGE_NETFILTER
./scripts/config --enable IPV6

./scripts/config --enable CONFIG_PACKET
./scripts/config --enable VETH

./scripts/config --enable CONFIG_NF_TABLES
./scripts/config --enable CONFIG_NF_TABLES_BRIDGE

# --- NAT и соединения ---
./scripts/config --enable CONFIG_NF_NAT
./scripts/config --enable CONFIG_NF_CONNTRACK
./scripts/config --enable CONFIG_NF_DEFRAG_IPV4
./scripts/config --enable CONFIG_NF_DEFRAG_IPV6

# --- Xtables поверх nft (для iptables) ---
./scripts/config --enable CONFIG_NETFILTER_XTABLES
./scripts/config --enable CONFIG_NETFILTER_XT_NAT
./scripts/config --enable CONFIG_NETFILTER_XT_MATCH_ADDRTYPE
./scripts/config --enable CONFIG_NETFILTER_XT_MATCH_CONNTRACK
./scripts/config --enable CONFIG_NETFILTER_XT_MATCH_COMMENT
./scripts/config --enable CONFIG_NETFILTER_XT_MATCH_STATE
./scripts/config --enable CONFIG_NETFILTER_XT_TARGET_MASQUERADE

# --- iptables через nft (xtables-nft) ---
./scripts/config --enable CONFIG_IP_NF_IPTABLES
./scripts/config --enable CONFIG_IP_NF_FILTER
./scripts/config --enable CONFIG_IP_NF_MANGLE
./scripts/config --enable CONFIG_IP_NF_RAW
./scripts/config --enable CONFIG_IP_NF_NAT

./scripts/config --enable CONFIG_IP6_NF_IPTABLES
./scripts/config --enable CONFIG_IP6_NF_FILTER
./scripts/config --enable CONFIG_IP6_NF_MANGLE
./scripts/config --enable CONFIG_IP6_NF_RAW
./scripts/config --enable CONFIG_IP6_NF_NAT

./scripts/config --enable CONFIG_NFT_NAT
./scripts/config --enable CONFIG_NFT_MASQ
./scripts/config --enable CONFIG_NFT_REDIR
./scripts/config --enable CONFIG_NFT_COMPAT

./scripts/config --disable ARM_SCMI_TRANSPORT_VIRTIO
./scripts/config --disable DEBUG_INFO
./scripts/config --disable DEBUG_INFO_DWARF5

make ARCH=arm64 -j$(nproc) Image.gz

cp arch/arm64/boot/Image.gz ../../kernel/arm64/vmlinuz-${VERSION}
