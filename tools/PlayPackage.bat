@echo off
title play package
color A
rem ���������ӳ�
setlocal enabledelayedexpansion

rem ��ȡ�������������Ŀ·��
set /p IN_PATH=��������Ŀ����·������ģ��·��: 
set IN_PATH=%IN_PATH:/=\%
set IN_PATH=%IN_PATH:\\=\%

rem ���·��>D:\PlayPackage
set OUT_PATH=D:\PlayPackage
rem ���·��>����
rem set OUT_PATH=%userprofile%\Desktop
rem ���·��>��Ŀ����·��
rem set OUT_PATH=

set DT=%date:~2,2%%date:~5,2%%date:~8,2%
set TM=%time:~0,2%%time:~3,2%
set TM=%TM: =0%

rem ����·���Ƿ�Ϊ��ģ��·��
if exist "%IN_PATH%\conf\application.conf" (
	set IS_MAIN=1
) else (
	set IS_MAIN=0
)

cd /d "%IN_PATH%"

if "%IS_MAIN%" == "1" (
	cd ..
	set SPLIT_PATH="%IN_PATH%"
	
	rem ��ȡ��Ŀ����Ŀ¼��(��ȡ���һ��·����)
	:SPLIT
	for /f "delims=\ tokens=1,*" %%i in (!SPLIT_PATH!) do (
		if "%%j" == "" (
			set MAIN=%%i
			goto PACK
		)
		
		set SPLIT_PATH="%%j"
		goto SPLIT
	)
) else (
	for /f "delims= tokens=*" %%i in ('dir /b') do (
		set MODULE=%%i
		rem set ATTR=%%~ai

		rem �Ƿ�ΪĿ¼
		rem if "!ATTR:~0,1!" == "d" (
			if exist "%IN_PATH%\!MODULE!\conf\application.conf" (
				set MAIN=!MODULE!
				goto PACK
			)
		rem )
	)
)

:PACK
if "%OUT_PATH%" == "" set OUT_PATH=%cd%
set OUT_PATH=%OUT_PATH%\%MAIN:.main=%_%DT%%TM%

echo.    
echo      / )
echo    /  /________
echo _/      _______)���·��:%OUT_PATH%
echo         __)
echo _       _)
echo  \______)
echo.

rem ���
rem ��ʹ��call����ʱ,���ڴ������ִ������Զ��˳�
call play war %MAIN% --exclude .svn:logs:target:tmp -o %OUT_PATH%
if not "%errorlevel%" == "0" echo ���ʧ��... && goto FAIL

rem ȥԴ��
if not exist "%OUT_PATH%\WEB-INF\application\app" echo ȥԴ��ʧ��... && goto END
if not exist "%OUT_PATH%\WEB-INF\application\modules" echo ȥԴ��ʧ��... && goto END

cd /d "%OUT_PATH%\WEB-INF\application\app"
:CLEAR
for /f "delims= tokens=*" %%i in ('dir /s /b') do (
	set FILE=%%i
	
	rem ɾ������.java�ļ�
	if "!FILE:~-5!" == ".java" (
		echo ɾ�� %%i
		del /a /f /q %%i
	)
	rem ��հ���.htmlԴ������
	if "!FILE:~-5!" == ".html" (
		echo ��� %%i
		cd. > %%i
	)
)
if "%cd%" == "%OUT_PATH%\WEB-INF\application\app" cd /d "%OUT_PATH%\WEB-INF\application\modules" && goto CLEAR

:END
echo.    
echo      / )
echo    /  /________
echo _/      _______)���·��:%OUT_PATH%
echo         __)
echo _       _)
echo  \______)
echo.

:FAIL
pause
