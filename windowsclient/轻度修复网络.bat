@echo off
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
NETSH WINHTTP RESET PROXY
systeminfo>%~dp0tmpall.txt
for /f "tokens=2 delims=:" %%a in ('findstr /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" %~dp0tmpall.txt') do (set ip=%%a)
if not defined ip echo ������У԰����ʼ����ʹ��ǿ���޸� & pause & exit
::��ȡgate��û�������룩
for /f "tokens=1,2 delims=. " %%a in ('echo %ip%') do (set gate=%%a.%%b.0.1)
::��ȡ������������
for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" %~dp0tmpall.txt') do (set wei2=%%a)
if not defined wei2 goto du
set /a wei2=%wei2% - 5
set "mainnamet="
for /f "skip=%wei2% tokens=2* delims=:" %%a in (%~dp0tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
set mainname="%var%"
netsh interface ip set interface %mainname% ignoredefaultroutes=disabled
route add 0.0.0.0 mask 0.0.0.0 %gate%
netsh interface ip set dns name=%mainname% source=dhcp
netsh interface ip set address name=%mainname% source=dhcp
echo ���û���޸�ʹ��ǿ���޸�








