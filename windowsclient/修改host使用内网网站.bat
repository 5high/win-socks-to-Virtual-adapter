Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd C:\Windows\System32\drivers\etc\
if exist hosts.bak (echo "����Ӧ�ù�����㿪��ԭ������" & pause &exit)
copy hosts hosts.bak
echo �������Ϊhosts.bak
cd "%~dp0"
if not exist result.txt (echo ��������result & pause & exit)
for /f "tokens=1,2 delims= " %%a in (result.txt) do (echo %%a %%b>>C:\Windows\System32\drivers\etc\hosts)
ipconfig /flushdns
echo �޸����
pause