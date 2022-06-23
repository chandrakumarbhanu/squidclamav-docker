#!/bin/bash
apt-get update
apt-get install -y vim
apt-get install -y procs
apt-get install -y squid
apt-get install -y patch
apt-get install -y libicapapi-dev
apt-get install -y libc-dev
apt-get install -y file
apt-get install -y wget
apt-get install -y gcc
apt-get install -y ca-certificates
apt-get install -y make
apt-get install -y libicapapi5
apt-get install -y libbz2-dev
apt-get install -y zlib1g-dev
echo "icap_enable on" >> /etc/squid/squid.conf
echo "icap_send_client_ip on" >> /etc/squid/squid.conf
echo "icap_send_client_username on" >> /etc/squid/squid.conf
echo "icap_client_username_encode off" >> /etc/squid/squid.conf
echo "icap_client_username_header X-Authenticated-User" >> /etc/squid/squid.conf
echo "icap_preview_enable on" >> /etc/squid/squid.conf
echo "icap_preview_size 1024" >> /etc/squid/squid.conf
echo "icap_service service_avi_req reqmod_precache icap://127.0.0.1:1344/squidclamav bypass=off" >> /etc/squid/squid.conf
echo "adaptation_access service_avi_req allow all" >> /etc/squid/squid.conf
echo "icap_service service_avi_resp respmod_precache icap://127.0.0.1:1344/squidclamav bypass=on" >> /etc/squid/squid.conf
echo "adaptation_access service_avi_resp allow all" >> /etc/squid/squid.conf
echo "Service squidclamav squidclamav.so" >> /etc/c-icap/c-icap.conf
sed -i 's,enable_libarchive ,#enable_libarchive ' >> /etc/c-icap/squidclamav.conf
sed -i 's,banmaxsize ,#banmaxsize ' >> /etc/c-icap/squidclamav.conf
apt-get -y install git
rm -rf /usr/lib/x86_64-linux-gnu/c_icap/squidclamav.la
rm -rf /usr/lib/x86_64-linux-gnu/c_icap/squidclamav.so
mkdir -p /opt/csw/
git clone --recursive https://github.com/darold/squidclamav.git "/usr/src/squidclamav"
cd /usr/src/squidclamav
./configure --with-c-icap=/etc/c-icap --with-libarchive=/opt/csw/
make
make install
apt-get install -y clamav
cd /
wget --user-agent='CVUPDATE/14 (33fde49b-905f-43c6-a51b-e1324cd23280)' https://database.clamav.net/main.cvd https://database.clamav.net/daily.cvd https://database.clamav.net/bytecode.cvd
cp daily.cvd bytecode.cvd main.cvd /var/lib/clamav/
chown clamav:clamav /var/lib/clamav
chown clamav:clamav /var/lib/clamav/main.cvd
chown clamav:clamav /var/lib/clamav/daily.cvd
chown clamav:clamav /var/lib/clamav/bytecode.cvd
chmod -R 777 /var/lib/clamav/
apt-get -y install clamav-daemon
/etc/init.d/clamav-daemon force-reload
wget --no-check-certificate https://secure.eicar.org/eicar_com.zip
apt-get install -y net-tools
/etc/init.d/squid reload
mkdir -p /var/run/c-icap
chown c-icap:c-icap /var/run/c-icap
/etc/init.d/squid restart
c-icap -d 10 -f /etc/c-icap/c-icap.conf
tail -f /dev/null
