@echo off
::Ȩ�޼��
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd "%~dp0"
::�ػ���ת
if "%1"=="h" goto begin
set count=1
:check
systeminfo>tmpall.txt
::���ipv6
for /f "tokens=*" %%a in ('findstr /r "200[0-9]:.*:.*:.*:.*:.*" tmpall.txt') do (set ipv6=%%a )
if defined ipv6 goto ok
echo ò����û��ipv6�����ڳ������»�ȡ��%count%��
start ipconfig /renew6
choice /t 3 /d y /n >nul
set /a count=%count% + 1
if %count%==5 (echo �޷��Զ���ȡipv6 �����ǲ�����ipv6���� & pause & exit)
goto check
:ok
::���tap����
for /f "tokens=1 delims=[] " %%a in ('find /n "TAP" tmpall.txt') do (set wei=%%a)
if %wei%==---------- call :checkd&&goto check
::������
tasklist|find /i "ShadowsocksR"
if %errorlevel% == 0 (taskkill /F /im ShadowsocksR*)
::��ȡssr�����ļ�
for /f "tokens=1,2,3 delims=, " %%a in ('find /i "index" gui-config.json') do (set ser=%%c)
::���������ļ���Ӧ����ֶ�����ipv4��ַ
::if "%ser%"=="0" (set server=*.*.*.*:7300)
::if "%ser%"=="1" (set server=*.*.*.*:7300)
::-----------------------------------------------
findstr /c:"Windows 10" tmpall.txt
if %errorlevel% == 0 set sy=1
findstr /c:"Windows 8" tmpall.txt
if %errorlevel% == 0 set sy=1
if defined sy (start ShadowsocksR-dotnet4.0.exe) else start ShadowsocksR-dotnet2.0.exe
::��ȡtap����������
set "dnamet="
for /f "skip=%wei%  tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined dnamet set "dnamet=%%a")
for /f "tokens=* delims= " %%a in ("%dnamet%") do call :ie "%%a"
set dname="%var%"
::����ת�����޸�������
netsh interface ipv4 set interface %dname% enable
::�޸�tap ip
netsh interface ipv4 add dns name=%dname% addr=8.8.8.8 index=1 validate=no
netsh interface ip set address name=%dname% source=static addr=192.168.222.1 mask=255.255.255.0
choice /t 1 /d y /n >nul
::����tun2socks����
start badvpn-tun2socks --tundev tap0901:%dname%:192.168.222.1:192.168.222.0:255.255.255.0 --netif-ipaddr 192.168.222.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr %server%
::--loglevel 1
::��ȡ������������
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set wei2=%%a)
if not defined wei2 goto du
set /a wei2=%wei2% - 4
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "\[[0-9][0-9]\]" tmpall.txt') do (if %%a==%wei2% set cut=1)
if not "1"=="%cut%" set /a wei2=%wei2%-1
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
echo %mainname%>>testlog.txt
::�޸���������dns
::netsh interface ip set interface %mainname% ignoredefaultroutes=enabled
netsh interface ipv4 del dns name=%mainname% all
netsh interface ipv4 add dns name=%mainname% addr=8.8.8.8 index=1 validate=no
::��ȡip(�޼��)
::ipconfig > tmp.txt
::for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmp.txt') do (set wei3=%%a)
::for /f "tokens=3 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmp.txt') do (set ip=%%a)
::ip��mask���пո�
::set "mask="
::for /f "skip=%wei3% tokens=2 delims=:" %%a in (tmp.txt) do (if not defined mask set "mask=%%a")
::netsh interface ipv4 add address name=%mainname% address=%ip% mask=%mask%
::
::��ȡgate��û�������룩
::for /f  %%a in ('ipconfig ^| findstr /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"') do (set gate=%%a)
::��ȡgate��route��ʽ��
:getgate
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
if not defined gate (
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<10.0.0.0\>"') do (set gate=%%a)
)
::��ʱ6��
choice /t 5 /d y /n >nul
::����·��
route delete 0.0.0.0
route add 10.0.0.0 mask 255.0.0.0 %gate% 
:du
if not defined wei2 choice /t 6 /d y /n >nul
route add 0.0.0.0 mask 0.0.0.0 192.168.222.2
if not defined gate exit
::�ػ����̣����ش��ڣ�
start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin
::��ȡ������������
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set wei2=%%a)
set /a wei2=%wei2% - 4
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "\[[0-9][0-9]\]" tmpall.txt') do (if %%a==%wei2% set cut=1)
if not "1"=="%cut%" set /a wei2=%wei2%-1
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
:begin2
::set gate=%2
::����Ϊ����������������ɺ���pause set/p�Ƚ�������
::������
choice /t 10 /d y /n >nul
tasklist|find /i "badvpn-tun2socks.exe"
if not %errorlevel% == 0 (
call :fix
exit
)
set "gate="
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
if defined gate (
route delete 0.0.0.0 mask 0.0.0.0 %gate%
route add 10.0.0.0 mask 255.0.0.0 %gate%
)
goto begin2
:fix
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<10.0.0.0\>"') do (set gate=%%a)
route add 0.0.0.0 mask 0.0.0.0 %gate%
route delete 10.0.0.0 mask 255.0.0.0 %gate%
netsh interface ip set dns name=%mainname% source=dhcp
goto :EOF
::ɾ��ǰ��ո�ĺ���
:ie str 
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
goto :EOF
:checkd
set qu=  
set /p qu= ò����û�а�װ������Ҫ��װô,����ظ����ֶ���װtap-windows��y/n��
if /i "%qu%"=="y" start /w "" tap-windows-9.9.2_3.exe 
if not %errorlevel% == 0 (echo ���ֶ���װtap-windows-9.9.2_3.exe����� & pause)
if /i "%qu%"=="n" exit
