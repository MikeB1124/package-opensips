apt update -y
apt install -y \
    git \
    make \
    gcc \
    bison \
    flex \
    pkg-config \
    openssl \
    libssl-dev \
    libsctp-dev \
    libmariadb-dev \
    libmariadb-dev-compat \
    libpq-dev \
    unixodbc-dev \
    libexpat1-dev \
    libxml2-dev \
    libxmlrpc-core-c3-dev \
    libperl-dev \
    libsnmp-dev \
    libldap2-dev \
    libconfuse-dev \
    libncurses5-dev \
    m4 \
    gawk \
    sed \
    tar \
    gzip \
    libevent-dev \
    libpcre2-dev \
    libncurses5-dev \
    libncursesw5-dev \
    mariadb-server \
    libpcre3-dev

sudo systemctl start mariadb

git clone --recurse-submodules https://github.com/OpenSIPS/opensips.git -b 3.3 opensips-3.3 /tmp/opensips
cd /tmp/opensips
#nned to enable my_sql module
make all
make install
make modules=modules/tls_mgm install
make modules=modules/db_mysql install
make modules=modules/sipcapture install
make modules=modules/freeswitch install
make modules=modules/freeswitch_scripting install



#opensips-cli
curl https://apt.opensips.org/opensips-org.gpg -o /usr/share/keyrings/opensips-org.gpg
echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bookworm cli-nightly" >/etc/apt/sources.list.d/opensips-cli.list
apt install opensips-cli -y

opensips-cli -x database create