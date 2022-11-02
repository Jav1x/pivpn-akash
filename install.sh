#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/Jav1x/testnet_manuals/main/logo.sh)
runsvdir -P /etc/service &
cp /usr/lib/go-1.18/bin/go /usr/bin/
# ++++++++++++ Установка удаленного доступа ++++++++++++++
echo 'export MY_ROOT_PASSWORD='${MY_ROOT_PASSWORD} >> /root/.bashrc
apt -y install tmate
cd /
mkdir /root/tmate
mkdir /root/tmate/log
cat > /root/tmate/run <<EOF 
#!/bin/bash
exec 2>&1
exec tmate -F
EOF
chmod +x /root/tmate/run
LOG=/var/log/tmate
echo 'export LOG='${LOG} >> $HOME/.bashrc
cat > /root/tmate/log/run <<EOF 
#!/bin/bash
mkdir $LOG
exec svlogd -tt $LOG
EOF
chmod +x /root/tmate/log/run
ln -s /root/tmate /etc/service

if [[ -n $MY_ROOT_PASSWORD ]]
then
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${MY_ROOT_PASSWORD}; echo ${MY_ROOT_PASSWORD}) | passwd root && service ssh restart
else
apt install -y goxkcdpwgen 
MY_ROOT_PASSWORD=$(goxkcdpwgen -n 1)
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${MY_ROOT_PASSWORD}; echo ${MY_ROOT_PASSWORD}) | passwd root && service ssh restart
echo ===========================
echo SSH PASS: $MY_ROOT_PASSWORD
echo ===========================
sleep 20
