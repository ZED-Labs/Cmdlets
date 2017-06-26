#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
echo Installing...
echo    libicu, libunwind, unzip, and uuid...
yum install -y libicu libunwind unzip uuid > /dev/null
echo    openssl...
if ! rpm -qa | grep libcurl-openssl-7.51.0-2.1.el7; then
    rpm -ivh ./Include/libcurl-openssl-7.51.0-2.1.el7.cern.x86_64.rpm > /dev/null
fi
echo export LD_LIBRARY_PATH=/opt/shibboleth/lib64/:\$LD_LIBRARY_PATH >> /etc/bashrc
export LD_LIBRARY_PATH=/opt/shibboleth/lib64/:$LD_LIBRARY_PATH
echo    powershell core...
if ! rpm -qa | grep powershell-6.0.0_beta.3-1.el7; then
    if rpm -qa | grep powershell; then
        rpm -e powershell
    fi
    rpm -ivh ./Include/powershell-6.0.0_beta.3-1.el7.x86_64.rpm > /dev/null
fi
