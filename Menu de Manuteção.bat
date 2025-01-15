@echo off
color 0C

title Menu de Manutecao de Micro By [K]

:: Verifica se o script está sendo executado como administrador
openfiles >nul 2>&1
if %errorlevel% neq 0 (
	cls
	echo.
	echo [=============================================================]
	echo [#########                                           #########]
	echo [#########              MENU PRINCIPAL               #########]
	echo [#########                                           #########]
	echo [=============================================================]
	echo.
	echo      O script nao esta rodando com administrador,
	echo      tentando reiniciar como administrador.
	echo.
	echo [=============================================================]
	echo.
	powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

##################################################################################################################################################
:menu

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########              MENU PRINCIPAL               #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo        1. Ativar o Windows e Office (Online).
echo.
echo        2. Ativar o WinRAR.
echo.
echo        3. Atualizar aplicativos do Windows (Winget).
echo.
echo        4. Menu Xbox GameBar.
echo.
echo        5. Menu completo do botao direto Windows 11.
echo.
echo        6. Restaura visualizador de imagens do Windows 10.
echo.
echo        7. Menu do MPO (Multi-Plane Overlay).
echo.
echo        8. Verificar Integridade do Sistema (DISM e SFC).
echo.
echo        9. Verificar Disco (chkdsk).
echo.
echo [=============================================================]
echo.
echo.
choice /c 1234567890 /n /m ">>>Digite o numero da opcao desejada, ou 0 p/ Sair: "

rem Usando a escolha do usuario
set _el=%errorlevel%

if %_el%==1 goto ativar_windows
if %_el%==2 goto ativa_winrar
if %_el%==3 goto atualizar_app_windows
if %_el%==4 goto menu_remove_xbox
if %_el%==5 goto botao_direitow11
if %_el%==6 goto visualizador_win10
if %_el%==7 goto menu_mpo
if %_el%==8 goto ver_integridade_sistema
if %_el%==9 goto ver_disco
if %_el%==10 goto sair

rem Caso a opcao seja invalida
echo Opcao invalida. Tente novamente.
pause
goto menu

##################################################################################################################################################
:ativar_windows

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########   Ativando o Windows via PowerShell...    #########]
echo [#########                                           #########]
echo [=============================================================]
echo.

:: Comando PowerShell para baixar e executar o script
powershell -Command "irm https://massgrave.dev/get | iex"

goto menu

##################################################################################################################################################
:ativa_winrar

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########            Ativando o WinRAR              #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.

:: Criar o arquivo rarreg.key com o conteúdo especificado
echo RAR registration data> "%ProgramFiles%\WinRAR\rarreg.key"
echo WinRAR>> "%ProgramFiles%\WinRAR\rarreg.key"
echo Unlimited Company License>> "%ProgramFiles%\WinRAR\rarreg.key"
echo UID=4b914fb772c8376bf571>> "%ProgramFiles%\WinRAR\rarreg.key"
echo 6412212250f5711ad072cf351cfa39e2851192daf8a362681bbb1d>> "%ProgramFiles%\WinRAR\rarreg.key"
echo cd48da1d14d995f0bbf960fce6cb5ffde62890079861be57638717>> "%ProgramFiles%\WinRAR\rarreg.key"
echo 7131ced835ed65cc743d9777f2ea71a8e32c7e593cf66794343565>> "%ProgramFiles%\WinRAR\rarreg.key"
echo b41bcf56929486b8bcdac33d50ecf773996052598f1f556defffbd>> "%ProgramFiles%\WinRAR\rarreg.key"
echo 982fbe71e93df6b6346c37a3890f3c7edc65d7f5455470d13d1190>> "%ProgramFiles%\WinRAR\rarreg.key"
echo 6e6fb824bcf25f155547b5fc41901ad58c0992f570be1cf5608ba9>> "%ProgramFiles%\WinRAR\rarreg.key"
echo aef69d48c864bcd72d15163897773d314187f6a9af350808719796>> "%ProgramFiles%\WinRAR\rarreg.key"

:: Exibe uma mensagem indicando que o arquivo foi criado
echo O arquivo rarreg.key foi criado com sucesso em "%ProgramFiles%\WinRAR",

pause
goto menu

##################################################################################################################################################
:ver_integridade_sistema

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########   Verificando ScanHealth do sistema...    #########]
echo [#########                                           #########]
echo [=============================================================]
echo.

:: Primeiro comando DISM para verificar a integridade da imagem do Windows
DISM /Online /Cleanup-Image /ScanHealth
echo.
echo.


cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########  Verificando RestoreHealth do sistema...  #########]
echo [#########                                           #########]
echo [=============================================================]
echo.

:: Segundo comando DISM para reparar a imagem do Windows, se necessário
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo.


cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########   Verificando SFC /SCANNOW do sistema...  #########]
echo [#########                                           #########]
echo [=============================================================]
echo.

:: Comando SFC para verificar e reparar arquivos de sistema
sfc /scannow
echo.
echo.

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########   Verificacao concluida com sucesso...    #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.

pause
goto menu

##################################################################################################################################################
:ver_disco

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########    Iniciando a verificacao do disco...    #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.

:: Informando sobre o reinicio do sistema
echo O sistema sera reiniciado para realizar a verificacao do disco.
set /p confirm= Deseja prosseguir? (S/N):

if /I "%confirm%"=="S" (
    echo Executando chkdsk C: /f /r...
    echo S | chkdsk C: /f /r
    echo.
    echo O sistema sera reiniciado...
    shutdown /r /t 0
) else (
    goto menu
)

pause
goto menu

##################################################################################################################################################
:atualizar_app_windows

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########      Atualizando os aplicativos...        #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.

:: Atualiza todos os aplicativos instalados, incluindo os desconhecidos, usando o winget
winget upgrade --all --include-unknown

:: Mensagem de sucesso
echo.
echo Todos os aplicativos foram atualizados com sucesso,
pause
color 0C
goto menu

##################################################################################################################################################
:menu_remove_xbox

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########               Menu Xbox                   #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo                  1. Remover o XboxGameBar.
echo.
echo                  2. Restaura o XboxGameBar.
echo.
echo [=============================================================]
echo.
echo.
choice /c 123 /n /m ">>>Digite o numero da opcao desejada, ou 3 p/ Sair: "

set _el=%errorlevel%

if %_el%==1 goto xbox_0
if %_el%==2 goto xbox_1
if %_el%==3 goto menu

rem Caso a opcao seja invalida
goto menu_remove_xbox

##################################################################################################################################################
:xbox_0

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########           Removendo XboxGameBar           #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.
reg add HKCR\ms-gamebar /f /ve /d URL:ms-gamebar 2>&1 >''

reg add HKCR\ms-gamebar /f /v "URL Protocol" /d " " 2>&1 >''

reg add HKCR\ms-gamebar /f /v "NoOpenWith" /d " " 2>&1 >''

reg add HKCR\ms-gamebar\shell\open\command /f /ve /d "`"$env:SystemRoot\System32\systray.exe`"" 2>&1 >''

reg add HKCR\ms-gamebarservices /f /ve /d URL:ms-gamebarservices 2>&1 >''

reg add HKCR\ms-gamebarservices /f /v "URL Protocol" /d " " 2>&1 >''

reg add HKCR\ms-gamebarservices /f /v "NoOpenWith" /d " " 2>&1 >''

reg add HKCR\ms-gamebarservices\shell\open\command /f /ve /d "`"$env:SystemRoot\System32\systray.exe`"" 2>&1 >''

echo Xbox Game Bar removido e Game DVR desabilitado com sucesso,

pause
goto menu

##################################################################################################################################################
:xbox_1

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########          Restaurando XboxGameBar          #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.
reg add HKCR\ms-gamebar /f /ve /d "URL:ms-gamebar"

reg delete HKCR\ms-gamebar /f /v "NoOpenWith"

reg add HKCR\ms-gamebar /f /v "URL Protocol" /d ""

reg add HKCR\ms-gamebarservices /f /ve /d "URL:ms-gamebarservices"

reg delete HKCR\ms-gamebar\shell /f

reg delete HKCR\ms-gamebarservices /f /v "NoOpenWith"

reg delete HKCR\ms-gamebarservices\shell /f

echo Xbox Game Bar reativado e Game DVR habilitado com sucesso,

pause
goto menu

##################################################################################################################################################
:botao_direitow11

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########          Ativando botao direito           #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.

REM Habilitar menu do botao direito completo
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
echo.
echo Menu do botao direito completo ativado com sucesso,
pause
goto menu

##################################################################################################################################################
:visualizador_win10

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########          Ativando visualizador            #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.

regedit /s Visualizador_de_imagens_W10.reg
echo Visualizador de imagem do Windows 10 re-ativado com sucesso,
pause
goto menu

##################################################################################################################################################
:menu_mpo

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########               Menu do MPO                 #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo      1. Desativar o MPO (Melhora performace placa de video).
echo.
echo      2. Restaura o MPO.
echo.
echo [=============================================================]
echo.
echo.
choice /c 123 /n /m ">>>Digite o numero da opcao desejada, ou 3 p/ Sair: "

set _el=%errorlevel%

if %_el%==1 goto mpo_0
if %_el%==2 goto mpo_1
if %_el%==3 goto menu

rem Caso a opcao seja invalida
goto menu_mpo

##################################################################################################################################################
:mpo_0

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########             Desativando MPO               #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /t REG_DWORD /d 5 /f
echo.
echo MPO desabilitado,
pause
goto menu

##################################################################################################################################################
:mpo_1

cls
echo.
echo [=============================================================]
echo [#########                                           #########]
echo [#########              Ativando MPO                 #########]
echo [#########                                           #########]
echo [=============================================================]
echo.
echo.
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /f
echo.
echo MPO habilitado,
pause
goto menu

##################################################################################################################################################
:sair

exit