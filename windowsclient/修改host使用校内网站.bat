Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
cd C:\Windows\System32\drivers\etc\
if exist hosts.bak (echo "����Ӧ�ù�����㿪��ԭ������" & pause &exit)
copy hosts hosts.bak
echo �������Ϊhosts.bak
echo 10.1.10.253  www.bitunion.org >>hosts
echo 10.0.6.51  jwc.bit.edu.cn >>hosts
echo 10.102.50.253  9stars.org >>hosts
echo 10.4.51.158  bbs.century.bit.edu.cn >>hosts
echo 10.0.8.105  hq.bit.edu.cn >>hosts
echo 10.51.69.160  www.bitfx.org >>hosts
echo 10.133.21.233  bbs.bit.edu.cn >>hosts
ipconfig /flushdns
echo �޸����
pause