@echo off
::Ȩ�޼��
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd /d "%~dp0"
if exist tmp.pid echo "�ϴ�û�������رգ��ػ��ȷ�ʽ��������������ʹ������޸�"
::�ػ���ת
if "%1"=="h" goto begin
set count=1
:check
systeminfo>tmpall.txt
::���߼��(���Ŀ�ȥ��ֻ����һ��)
for /f "tokens=2" %%a in ('netsh interface show interface') do (if %%a==������ set net=1)
if not ��%net%��==��1�� (
echo �����������Ƿ����ӻ�����Ӣ��ϵͳ��
pause
systeminfo>tmpall.txt
)
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
for /f "tokens=1 delims=[] " %%a in ('find /n "TAP-Windows" tmpall.txt') do (set wei=%%a)
if %wei%==---------- call :checkd&&goto check
::������
tasklist|find /i "gotun2socks"
if %errorlevel% == 0 (echo �����Ѿ���������&pause&exit)
tasklist|find /i "ShadowsocksR"
if %errorlevel% == 0 (goto ssr)
findstr /c:"Windows 10" tmpall.txt
if %errorlevel% == 0 set sy=1
findstr /c:"Windows 8" tmpall.txt
if %errorlevel% == 0 set sy=1
if defined sy (start ShadowsocksR-dotnet4.0.exe) else start ShadowsocksR-dotnet2.0.exe
:ssr
::��ȡtap����������
set "dnamet="
for /f "skip=%wei%  tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined dnamet set "dnamet=%%a")
for /f "tokens=* delims= " %%a in ("%dnamet%") do call :ie "%%a"
set dname="%var%"
echo %dname%
::����gotun2socks����
start gotun2socks -enable-dns-cache -tun-address 192.168.222.1 -tun-gw 192.168.222.2 -tun-mask 255.255.255.0
::�޸�tap ip
choice /t 1 /d y /n >nul
netsh interface ipv4 add dns name=%dname% addr=8.8.8.8 index=1 validate=no
netsh interface ip set address name=%dname% source=static addr=192.168.222.1 mask=255.255.255.0
::��ȡ�����������ƺ��������Ƶ�һ�������ʣ�ipv6��
for /f "tokens=1,2 delims=:[] " %%a in ('findstr /n /r "200[0-9]:.*:.*:.*:.*:.*" tmpall.txt') do (set wei2=%%a&set minus=%%b)
if not defined wei2 goto du
set /a wei2=%wei2%-%minus%-3
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "\[[0-9][0-9]\]" tmpall.txt') do (if %%a==%wei2% set cut=1)
if not "1"=="%cut%" set /a wei2=%wei2%-1
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
set /a wei2=%wei2%-1
set "mainnamef="
for /f "skip=%wei2% tokens=2,3 delims=: " %%a in (tmpall.txt) do (if not defined mainnamef set "mainnamef=%%a %%b")
echo %mainnamef%
::�޸���������dns
::netsh interface ip set interface %mainname% ignoredefaultroutes=enabled
netsh interface ipv4 del dns name=%mainname% all
netsh interface ipv4 add dns name=%mainname% addr=8.8.8.8 index=1 validate=no
ipconfig /flushdns
::����ر�
echo %mainname%>tmp.pid
:getgate
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
if not defined gate (call :a1)
for /f "tokens=1 delims=." %%a in ('route print ^| findstr "TAP-Windows"') do (set ift=%%a)
for /f "tokens=1 delims=." %%a in ('route print ^| findstr "%mainnamef%"') do (set iff=%%a)
::make sure
if "%ift%"=="" echo ʧ�� & goto getgate
if "%iff%"=="" echo ʧ�� & goto getgate
::echo %ift%>chuanift.txt
::echo %iff%>chuaniff.txt
::��ʱ6��
choice /t 6 /d y /n >nul
::����·��
route delete 0.0.0.0
route add 10.0.0.0 mask 255.0.0.0 %gate% if %iff%
:du
if not defined wei2 choice /t 6 /d y /n >nul
route add 0.0.0.0 mask 0.0.0.0 192.168.222.2 if %ift%
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<192.168.222.2\>"') do (if "%%a"=="" route add 0.0.0.0 mask 0.0.0.0 192.168.222.2 if %ift%)
::if not defined gate exit
::�ػ����̣����ش���,��ϲ����ע�͵�����һ�У�
start mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin
:begin2
::����Ϊ����������������ɺ���pause set/p�Ƚ�������
::������
choice /t 10 /d y /n >nul
tasklist|find /i "gotun2socks"
if not %errorlevel% == 0 (
call :fix
exit
)
set "gate="
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
if defined gate (call :resetgate)
for /f "tokens=2 delims=(%%" %%a in ('ping -6 ipv6.baidu.com') do (if "%%a"=="100" ipconfig /renew6)
choice /t 10 /d y /n >nul
goto begin2

:fix
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<10.0.0.0\>"') do (set gate=%%a)
route add 0.0.0.0 mask 0.0.0.0 %gate% if %iff%
route delete 10.0.0.0 mask 255.0.0.0 %gate%
netsh interface ip set dns name=%mainname% source=dhcp
netsh interface ip set address name=%mainname% source=dhcp
del tmp.pid
start ipconfig /renew
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
goto :EOF

:a1
for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<10.0.0.0\>"') do (set gate=%%a)
goto :EOF

:resetgate
route delete 0.0.0.0 mask 0.0.0.0 %gate%
route delete 10.0.0.0 mask 255.0.0.0
route add 10.0.0.0 mask 255.0.0.0 %gate% if %iff%
goto :EOF