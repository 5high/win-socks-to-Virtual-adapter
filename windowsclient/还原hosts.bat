Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd C:\Windows\System32\drivers\etc\
if not exist hosts.bak (echo "û�б��ݹ�" & pause &exit)
copy /y hosts.bak hosts
echo ��ԭ���
pause
exit