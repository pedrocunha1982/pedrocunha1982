@echo off
chcp 65001 >nul
title Dell BIOS Recovery - Preparar Pen USB
echo ============================================
echo  DELL BIOS RECOVERY - PREPARAR PEN USB
echo ============================================
echo.

:: Pedir Service Tag
set /p SERVICETAG="Introduz o Service Tag do Dell (ex: ABC1234): "
echo.

:: Verificar se tem pen USB
echo ATENCAO: Vai formatar a pen USB!
echo Certifica-te que a pen esta inserida e que nao tem ficheiros importantes.
echo.
echo Pens USB disponiveis:
wmic logicaldisk where "drivetype=2" get deviceid, volumename, size /format:list 2>nul
echo.
set /p DRIVE="Letra da pen USB (ex: E): "
echo.

echo ============================================
echo  PASSO 1: Formatar pen em FAT32
echo ============================================
echo A formatar %DRIVE%: em FAT32...
format %DRIVE%: /FS:FAT32 /Q /V:DELLBIOS /Y
if errorlevel 1 (
    echo ERRO: Nao foi possivel formatar. Verifica a letra da drive.
    pause
    exit /b 1
)
echo Pen formatada com sucesso!
echo.

echo ============================================
echo  PASSO 2: Descarregar BIOS
echo ============================================
echo.
echo A abrir a pagina de download da Dell para o Service Tag: %SERVICETAG%
echo.
echo INSTRUCOES:
echo  1. O browser vai abrir com a pagina do teu Dell
echo  2. Clica em "Controladores e transferencias" (Drivers ^& Downloads)
echo  3. Filtra por categoria "BIOS"
echo  4. Faz download do ficheiro .exe mais recente
echo  5. Quando o download terminar, fecha o browser e volta aqui
echo.
start https://www.dell.com/support/home/product-support/servicetag/%SERVICETAG%/drivers
echo.
echo Quando o download terminar, arrasta o ficheiro .exe para aqui
echo ou escreve o caminho completo:
echo.
set /p BIOSFILE="Caminho do ficheiro BIOS .exe: "
echo.

echo ============================================
echo  PASSO 3: Copiar e renomear para a pen
echo ============================================
echo A copiar e renomear para %DRIVE%:\BIOS_IMG.rcv ...
copy "%BIOSFILE%" "%DRIVE%:\BIOS_IMG.rcv" /Y
if errorlevel 1 (
    echo ERRO: Nao foi possivel copiar. Verifica o caminho do ficheiro.
    pause
    exit /b 1
)
echo.
echo ============================================
echo  TUDO PRONTO!
echo ============================================
echo.
echo O ficheiro BIOS_IMG.rcv esta na pen %DRIVE%:
echo.
echo Agora no Dell avariado:
echo  1. Desliga o Dell
echo  2. Insere a pen USB (porta PRETA, nao azul)
echo  3. Mantem premido Ctrl + Esc
echo  4. Liga o computador pelo botao power
echo  5. Mantem premido 30 segundos
echo  6. Espera a recuperacao terminar (NAO desligues!)
echo.
echo Verificacao - ficheiro na pen:
dir %DRIVE%:\BIOS_IMG.rcv
echo.
pause
