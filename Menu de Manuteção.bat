@echo off
title Menu de Manutencao de Micro do HC By [ K ]

:menu
color 0C
cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo            1. Ativar o Windows e Office (Online).
echo.
echo            2. Apagar informacoes do Google Chrome.
echo.
echo            3. Atualizar data e hora via 10.165.1.250.
echo.
echo            4. Ferramentas do Sistema (DISM e CheckDisk).
echo.
echo            5. Aplicativos (F-Secure e GLPI Agent).
echo.
echo            6. Sair
echo.
echo [==========================================================]
echo.
choice /c 123456 /n /m ">>>Digite o numero da opcao desejada, ou 6 p/ Sair: "

rem Usando a escolha do usuario
set _el=%errorlevel%

if %_el%==1 goto ativar_windows
if %_el%==2 goto apagar_informacoes_chrome
if %_el%==3 goto atualiza_hora_admin
if %_el%==4 goto menu_sistema
if %_el%==5 goto menu_aplicativos
if %_el%==6 goto sair

rem Caso a opcao seja invalida
echo Opcao invalida. Tente novamente.
pause
goto menu

:menu_sistema
cls
echo.
echo [==========================================================]
echo                ###   FERRAMENTAS DO SISTEMA   ###
echo [==========================================================]
echo.
echo            1. Verificar integridade do sistema.
echo.
echo            2. Verificar disco (chkdsk).
echo.
echo            3. Executar ambas verificacoes em sequencia.
echo.
echo            4. Limpar spooler de impressao.
echo.
echo            5. Voltar ao menu principal.
echo.
echo [==========================================================]
echo.
choice /c 12345 /n /m ">>>Digite o numero da opcao desejada, ou 5 p/ Voltar: "

set _el=%errorlevel%

if %_el%==1 goto verificar_integridade_admin
if %_el%==2 goto verificar_disco_admin
if %_el%==3 goto verificar_ambas
if %_el%==4 goto limpa_spooler_admin
if %_el%==5 goto menu

echo Opcao invalida. Tente novamente.
pause
goto menu_sistema

:verificar_ambas
cls
echo.
echo [==========================================================]
echo        EXECUTANDO VERIFICACOES DO SISTEMA EM SEQUENCIA
echo [==========================================================]
echo.
echo Primeiro: Verificando integridade do sistema...
echo.
pause
call :verificar_integridade_admin_no_return

cls
echo.
echo [==========================================================]
echo        EXECUTANDO VERIFICACOES DO SISTEMA EM SEQUENCIA
echo [==========================================================]
echo.
echo Segundo: Verificando disco...
echo.
pause
call :verificar_disco_admin_no_return

echo.
echo Todas as verificacoes foram concluidas.
pause
goto menu_sistema

:verificar_integridade_admin_no_return
:: Versão da função que não retorna ao menu
:: Verificar se o script esta rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador.
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Primeiro comando DISM para verificar a integridade da imagem do Windows
echo Executando DISM /Online /Cleanup-Image /ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth
echo.

:: Segundo comando DISM para reparar a imagem do Windows, se necessário
echo Executando DISM /Online /Cleanup-Image /RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
echo.

:: Comando SFC para verificar e reparar arquivos de sistema
echo Executando sfc /scannow...
sfc /scannow
echo.

echo Deseja reiniciar o sistema para concluir as verificacoes?
set /p confirm= Prosseguir? (S/N):

if /I "%confirm%"=="S" (
    echo O sistema sera reiniciado...
    pause
    shutdown /r /t 0
)
exit /b

:verificar_disco_admin_no_return
:: Versão da função que não retorna ao menu
:: Verificar se o script esta rodando com privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador,
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

echo O sistema sera reiniciado para realizar a verificacao do disco,
set /p confirm= Deseja prosseguir? (S/N):

if /I "%confirm%"=="S" (
    echo Executando chkdsk C: /f /r...
    echo S | chkdsk C: /f /r
    echo.
    echo O sistema sera reiniciado...
    pause
    shutdown /r /t 0
)
exit /b

:menu_aplicativos
cls
echo.
echo [==========================================================]
echo                ###   MENU DE APLICATIVOS   ###
echo [==========================================================]
echo.
echo            1. Instalar F-Secure.
echo.
echo            2. Instalar GLPI Agent.
echo.
echo            3. Voltar ao menu principal.
echo.
echo [==========================================================]
echo.
choice /c 123 /n /m ">>>Digite o numero da opcao desejada, ou 3 p/ Voltar: "

set _el=%errorlevel%

if %_el%==1 goto Instalar_fsecure
if %_el%==2 goto Instalar_glpi
if %_el%==3 goto menu

echo Opcao invalida. Tente novamente.
pause
goto menu_aplicativos

####################################################################################################################################################################
:ativar_windows

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo        Ativando o Windows via PowerShell...
echo.
echo [==========================================================]
echo.

:: Comando PowerShell para baixar e executar o script
powershell -Command "irm https://shre.ink/eyDm | iex"

goto menu


####################################################################################################################################################################
:apagar_informacoes_chrome

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo        Apagando informacoes do Google Chrome...
echo.
echo [==========================================================]
echo.

:: Verificar se o script esta sendo executado como administrador
openfiles >nul 2>&1
if %errorlevel% == 0 (
    echo.
    echo O script nao pode ser executado com privilegios de administrador,
    pause
    goto menu
)

:: Finalizar o Chrome.exe se estiver em execucao
taskkill /f /im chrome.exe >nul 2>&1

:: Deletar a pasta "User Data" do Chrome
echo Deletando pasta do Chrome User Data...
rmdir /s /q "%localappdata%\Google\Chrome\User Data"

:: Iniciar o Chrome.exe com o perfil do usuário logado
echo Iniciando o Google Chrome...
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --user-data-dir="%localappdata%\Google\Chrome\User Data"

goto sair


####################################################################################################################################################################
:verificar_integridade_admin

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo             Verificando integridade do sistema...
echo.
echo [==========================================================]
echo.

:: Verificar se o script esta rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador.
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Se estiver com privilegio de administrador, prosseguir com a verificacao
goto ver_integridade_sistema

:ver_integridade_sistema

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo             Verificando integridade do sistema...
echo.
echo [==========================================================]
echo.

:: Primeiro comando DISM para verificar a integridade da imagem do Windows
echo Executando DISM /Online /Cleanup-Image /ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth
echo.


cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo             Verificando integridade do sistema...
echo.
echo [==========================================================]
echo.

:: Segundo comando DISM para reparar a imagem do Windows, se necessário
echo Executando DISM /Online /Cleanup-Image /RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
echo.

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo             Verificando integridade do sistema...
echo.
echo [==========================================================]
echo.

:: Comando SFC para verificar e reparar arquivos de sistema
echo Executando sfc /scannow...
sfc /scannow
echo.
echo.

echo Deseja reiniciar o sistema para concluir as verificacoes,
set /p confirm= Prosseguir? (S/N):

if /I "%confirm%"=="S" (
    echo O sistema sera reiniciado...
    pause
    shutdown /r /t 0
) else (
    goto menu
)


####################################################################################################################################################################
:verificar_disco_admin

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo        Iniciando a verificacao do disco com CHKDSK...
echo.
echo [==========================================================]
echo.

:: Verificar se o script esta rodando com privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador,
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Se estiver com privilegio de administrador, prosseguir com a verificacao
goto ver_disco

:ver_disco

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo        Iniciando a verificacao do disco com CHKDSK...
echo.
echo [==========================================================]
echo.

:: Informando sobre o reinicio do sistema
echo O sistema sera reiniciado para realizar a verificacao do disco,
set /p confirm= Deseja prosseguir? (S/N):

if /I "%confirm%"=="S" (
    echo Executando chkdsk C: /f /r...
    echo S | chkdsk C: /f /r
    echo.
    echo O sistema sera reiniciado assim que...
    pause
    shutdown /r /t 0
) else (
    goto menu
)

pause
goto menu


####################################################################################################################################################################
:limpa_spooler_admin

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo               Limpando Spooler de impressao,
echo.
echo [==========================================================]
echo.

:: Verificar se o script esta rodando com privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador,
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

echo Interrompendo o Spooler
net stop spooler /y

echo Acessando a pasta de impressoras
cd %systemroot%\system32\spool\PRINTERS

echo Deletando os arquivos SHD
del /f /s *.shd

echo Deletando os arquivos SPL
del /f /s *.spl

echo Iniciando o Spooler
net start spooler
pause
goto menu


####################################################################################################################################################################
:atualiza_hora_admin

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo        Atualizando a hora via servidor: 10.165.1.250,
echo.
echo [==========================================================]
echo.

:: Verificar se o script esta rodando com privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador.
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Verificar se o servico Windows Time (w32time) está rodando
echo Verificando o status do servico Windows Time...
sc query w32time | find "RUNNING" >nul
if %errorlevel% neq 0 (
    echo.
    echo O servico Windows Time nao esta iniciado. Iniciando o servico...
    net start w32time
)

:: Atualizando a hora com o servidor NTP
echo.
echo Configurando o servidor NTP para sincronizacao...
w32tm /config /manualpeerlist:"10.165.1.250" /syncfromflags:manual /reliable:YES /update

:: Forcando a sincronizacao do tempo
echo.
echo Sincronizando a hora com o servidor NTP...
w32tm /resync

echo.
echo A hora foi atualizada com sucesso,
pause
goto menu


####################################################################################################################################################################
:Instalar_fsecure

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo                   Instalando o FSECURE,
echo.
echo [==========================================================]
echo.

:: Verificar se o script esta rodando com privilegios de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo O script nao esta rodando com administrador.
    echo Tentando reiniciar como administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

@echo off
SETLOCAL

REM Define o URL do arquivo MSI
SET "URL=http://10.165.23.226/FSECURE.msi"

REM Define o caminho onde o arquivo será salvo
SET "FILE=FSECURE.msi"

REM Baixa o arquivo usando PowerShell
powershell -command "Invoke-WebRequest -Uri '%URL%' -OutFile '%FILE%'"

REM Verifica se o download foi bem-sucedido
IF EXIST "%FILE%" (
    REM Executa o instalador com privilégios de administrador
    start /wait msiexec /i "%FILE%" /quiet /norestart
    echo Instalacao concluida,
) ELSE (
    echo Falha ao baixar o arquivo.
)

REM Limpa o arquivo após a instalação
DEL "%FILE%"

ENDLOCAL
pause

goto menu_aplicativos

####################################################################################################################################################################
:Instalar_glpi

cls
echo.
echo [==========================================================]
echo                ###   MENU PRINCIPAL   ###
echo [==========================================================]
echo.
echo                  Instalando o GLPI Agent,
echo.
echo [==========================================================]
echo.

setlocal enabledelayedexpansion

:: Configurações
set origem="\\10.165.23.226\arquivos\SCRIPTS\GLPI_Agent"
set destino="C:\GLPI_Agent"
set arquivo_instalador="%destino%\glpiagentinstall.bat"

:: Verifica se a pasta de origem existe
if not exist %origem% (
    echo.
    echo ERRO: Pasta de origem não encontrada!
    echo Verifique o caminho: %origem%
    echo Ou a conexão com o servidor 10.165.23.226
    pause
    exit /b
)

:: Cria a estrutura de pastas de destino
if not exist "C:\GLPI_Agent" mkdir "C:\GLPI_Agent"
if not exist %destino% mkdir %destino%

:: Copia todos os arquivos e subpastas
echo.
echo Copiando itens de %origem% para %destino%...
echo Por favor aguarde...
xcopy %origem% %destino% /E /H /C /I /Y /Q

:: Verifica se a cópia foi bem sucedida e executa o instalador
if exist %arquivo_instalador% (
    echo.
    echo Executando o instalador GLPI Agent...
    call %arquivo_instalador%
) else (
    echo.
    echo AVISO: Arquivo instalador não encontrado em:
    echo %arquivo_instalador%
)

pause
goto menu_aplicativos

####################################################################################################################################################################
:sair
exit
