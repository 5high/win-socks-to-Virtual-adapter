Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
NETSH WINHTTP RESET PROXY
cd "%~dp0"
::systeminfo>tmpall.txt
::for /f "tokens=2 delims=:" %%a in ('findstr /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set ip=%%a)
::if not defined ip ipconfig /renew &echo ������У԰����ʼ����ʹ��ǿ���޸� & pause & exit
::��ȡ������������
::for /f "tokens=1 delims=:" %%a in ('findstr /n /r "10\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" tmpall.txt') do (set wei2=%%a)
::if not defined wei2 goto du
::set /a wei2=%wei2% - 4
::for /f "tokens=1 delims=:" %%a in ('findstr /n /r "\[[0-9][0-9]\]" tmpall.txt') do (if %%a==%wei2% set cut=1)
::if not "1"=="%cut%" set /a wei2=%wei2%-1
::set "mainnamet="
::for /f "skip=%wei2% tokens=2* delims=:" %%a in (tmpall.txt) do (if not defined mainnamet set "mainnamet=%%a")
::for /f "tokens=* delims= " %%a in ("%mainnamet%") do call :ie "%%a"
::set mainname="%var%"
::netsh interface ip set interface %mainname% ignoredefaultroutes=disabled
::netsh interface ip set dns name=%mainname% source=dhcp
::netsh interface ip set address name=%mainname% source=dhcp
::��ȡgate��route��ʽ��
::for /f "tokens=3 delims= " %%a in ('route print ^| findstr "\<0.0.0.0\>"') do (if not %%a==192.168.222.2 set gate=%%a)
::��ȡ���������������ģ�
::for /f "tokens=2* delims=��:" %%a in ('ipconfig ^| findstr "��.* :$"') do (echo %%a>>shipei.txt)
route delete 10.0.0.0 mask 255.0.0.0
::��ȡ����������(����)
for /f "skip=3 tokens=3,* delims= " %%a in ('netsh interface show interface') do (echo "%%b">>shipei.txt)
::for /f "skip=3 tokens=3,* delims= " %%a in ('netsh interface show interface') do call :qukong "%%b" )
for /f "tokens=* delims= " %%a in (shipei.txt)do (netsh interface ip set address name=%%a source=dhcp)
for /f "tokens=* delims= " %%a in (shipei.txt)do (netsh interface ip set dns name=%%a source=dhcp)
del shipei.txt
ipconfig /renew
echo ���û���޸�ʹ��ǿ���޸�
pause
exit
::ɾ��ǰ��ո�ĺ���
:ie str
set "var=%~1"
if "%var:~-1%"==" "  call :ie "%var:~0,-1%"
goto :eof
::qukong str
::set "var=%~1"
::set "var=%var:~0,-1%"
::echo %var%>>shipei.txt






