#!/bin/bash
echo Installing...
echo    libicu, libunwind, unzip, and uuid...
yum install -y libicu libunwind unzip uuid > /dev/null
echo    openssl...
rpm -ivh ./Include/libcurl-openssl-7.51.0-2.1.el7.cern.x86_64.rpm > /dev/null
echo export LD_LIBRARY_PATH=/opt/shibboleth/lib64/:\$LD_LIBRARY_PATH >> /etc/bashrc
export LD_LIBRARY_PATH=/opt/shibboleth/lib64/:$LD_LIBRARY_PATH
echo    powershell core...
rpm -ivh ./Include/powershell-6.0.0_beta.3-1.el7.x86_64.rpm > /dev/null
echo    powercli...
mkdir -p /usr/local/share/powershell > /dev/null
mkdir -p /usr/local/share/powershell/Modules > /dev/null
#mkdir $CD/.local > /dev/null
#mkdir $HOME/.local/share > /dev/null
#mkdir $HOME/.local/share/powershell > /dev/null
#mkdir $HOME/.local/share/powershell/Modules > /dev/null

unzip -n ./Include/PowerCLI.ViCore.zip -d /usr/local/share/powershell/Modules > /dev/null
#unzip ./Include/PowerCLI.ViCore.zip -d $HOME/.local/share/powershell/Modules > /dev/null
echo    powercli-Vds...
unzip -n ./Include/PowerCLI.Vds.zip -d /usr/local/share/powershell/Modules > /dev/null
#unzip ./Include/PowerCLI.Vds.zip -d $HOME/.local/share/powershell/Modules > /dev/null
powershell -Command "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false"