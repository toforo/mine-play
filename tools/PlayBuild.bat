@echo off
title play build
color A

rem ��ȡ�������������Ŀ·��
set /p IN_PATH=��������Ŀ����·��: 
set IN_PATH=%IN_PATH:/=\%
set IN_PATH=%IN_PATH:\\=\%

cd /d "%IN_PATH%"

rem ��������
for /f "delims= tokens=*" %%i in ('dir /b') do (
	if exist "%IN_PATH%\%%i\conf\dependencies.yml" (
		rem ��������
		call play dependencies %%i
		
		rem ����eclipse�����ļ�
		call play eclipsify %%i
		rem ����IntelliJ Idea�����ļ�
		rem call play idealize %%i
	)
)

pause
