#!/bin/bash

set -e  # Exit on error

# Update package lists and install dependencies
apt update -y
apt install -y \
    git make gcc bison flex pkg-config openssl libssl-dev \
    libsctp-dev libmariadb-dev libmariadb-dev-compat libpq-dev unixodbc-dev \
    libexpat1-dev libxml2-dev libxmlrpc-core-c3-dev libperl-dev libsnmp-dev \
    libldap2-dev libconfuse-dev libncurses5-dev libncursesw5-dev libevent-dev \
    libpcre2-dev libpcre3-dev m4 gawk sed tar gzip mariadb-server sngrep net-tools \
    rsyslog

# Start MariaDB
systemctl start mariadb

# Clone OpenSIPS repo
OPENSiPS_DIR="/tmp/opensips"
if [ -d "$OPENSiPS_DIR" ]; then rm -rf "$OPENSiPS_DIR"; fi
git clone --recurse-submodules https://github.com/OpenSIPS/opensips.git -b 3.3 "$OPENSiPS_DIR"
cd "$OPENSiPS_DIR"

# Build and install OpenSIPS with required modules
make all
make install
make modules=modules/tls_mgm install
make modules=modules/db_mysql install
make modules=modules/sipcapture install
make modules=modules/freeswitch install
make modules=modules/freeswitch_scripting install

# Install OpenSIPS CLI
curl -fsSL https://apt.opensips.org/opensips-org.gpg -o /usr/share/keyrings/opensips-org.gpg
echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bookworm cli-nightly" >/etc/apt/sources.list.d/opensips-cli.list
apt update -y
apt install -y opensips-cli

# Create OpenSIPS database and enter password 
opensips-cli -x database create

cp /home/admin/package/opensips/opensips.cfg /usr/local/etc/opensips/opensips.cfg

cp /home/admin/package/opensips/rsyslog.conf /etc/ryslog.conf
systemctl restart rsyslog

cp /home/admin/package/opensips/opensips.service /etc/systemd/system/opensips.service
systemctl enable opensips
systemctl start opensips

echo "OpenSIPS installation completed successfully."