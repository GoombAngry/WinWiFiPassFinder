@echo off
setlocal enabledelayedexpansion


REM Guardamos la salida en un fichero temporal
netsh wlan show profile | findstr /C:"Perfil de todos los usuarios" /C:"All User Profile" > textTemp.txt

REM Fichero que guarda todas las passwords, cogeremos la fecha y hora del dia actual
set "fichero="

for /f "tokens=1,2,3 delims=/" %%a in ('date /t') do (
    set "date=%%a_%%b_%%c"
	set "fichero=!date:~0,-1!"
)

for /f "tokens=1,2 delims= " %%a in ('echo %TIME%') do (
    for /F "tokens=1,2,3 delims=:" %%f in ("%%a") do (
		set "fichero=%fichero%_%%f%%g%%h.txt"
    )
)
REM Fin para obtener el nombre del fichero

REM Obtenemos los nombre de los perfles y ejecutamos el comando por cada perfil obtenido
for /f "tokens=1,2 delims=:" %%a in (textTemp.txt) do (
    set "dato=%%b"
    REM Eliminar el primer carácter de la variable dato
    set "dato=!dato:~1!"
	set "fileTemp=tempFile.txt"
	netsh wlan show profile name="!dato!" key=clear | findstr /C:"Key Content" /C:"Contenido de la clave" > !fileTemp!
	for /f "tokens=1,2 delims=:" %%c in ('type "!fileTemp!"') do (
		set "password=%%d"
		set "password=!password:~1!"
		echo !dato!:!password! >> %fichero%
	)
	del "!fileTemp!"
)

REM Eliminar el archivo temporal
del textTemp.txt

endlocal


