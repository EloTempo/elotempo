@echo off
setlocal
chcp 65001 >nul 2>&1
title Elotempo - abrindo

rem ---------------------------------------------------------------------
rem Atalho de teste: deixa tudo em dia e abre o aplicativo.
rem
rem Nao e o instalador. Para gerar o instalador de verdade (MSI/NSIS), use
rem   npm run instalador
rem que faz a build de release com LTO e demora bem mais.
rem
rem Aqui o objetivo e o oposto: abrir rapido para testar. As duas builds sao
rem incrementais, entao sem mudancas isto leva poucos segundos.
rem ---------------------------------------------------------------------

pushd "%~dp0"

set "EXE=src-tauri\target\debug\elotempo.exe"

rem ---------------------------------------------------------------------
rem O aplicativo aberto trava o proprio .exe, e a build falha ao tentar
rem substitui-lo. Vale avisar antes de gastar um minuto compilando.
rem ---------------------------------------------------------------------
tasklist /FI "IMAGENAME eq elotempo.exe" 2>nul | find /I "elotempo.exe" >nul
if not errorlevel 1 (
    echo.
    echo   O aplicativo ja esta aberto.
    echo.
    echo   Feche a janela dele antes de rodar este atalho, senao a compilacao
    echo   nao consegue substituir o arquivo.
    echo.
    pause
    popd
    exit /b 1
)

rem ---------------------------------------------------------------------
rem Onde esta o cargo. Normalmente no PATH; o fallback cobre o caso de o
rem PATH nao ter sido recarregado desde a instalacao do Rust.
rem ---------------------------------------------------------------------
set "CARGO=cargo"
where cargo >nul 2>&1
if errorlevel 1 (
    if exist "%USERPROFILE%\.cargo\bin\cargo.exe" (
        set "CARGO=%USERPROFILE%\.cargo\bin\cargo.exe"
    ) else (
        echo.
        echo   Nao encontrei o cargo. Instale o Rust em https://rustup.rs
        echo.
        pause
        popd
        exit /b 1
    )
)

echo.
echo   [1/3] Frontend...
call npm run build --silent
if errorlevel 1 goto :falhou

rem ---------------------------------------------------------------------
rem O --features custom-protocol NAO e opcional.
rem
rem O Tauri decide dev vs. producao por essa feature, nao pelo perfil: em
rem tauri-2.x/build.rs, `dev = !custom_protocol`. Sem ela, o binario aponta
rem para o devUrl (localhost:1420) e abre com ERR_CONNECTION_REFUSED, porque
rem nao ha servidor de desenvolvimento no ar.
rem
rem Com ela, o frontend fica embutido e o perfil segue sendo debug, que
rem compila rapido. E o melhor dos dois para testar.
rem ---------------------------------------------------------------------
echo   [2/3] Rust... ^(a primeira vez demora; depois e rapido^)
"%CARGO%" build --manifest-path src-tauri/Cargo.toml --features custom-protocol --quiet
if errorlevel 1 goto :falhou

if not exist "%EXE%" (
    echo.
    echo   A compilacao terminou mas o executavel nao apareceu em:
    echo   %EXE%
    echo.
    pause
    popd
    exit /b 1
)

echo   [3/3] Abrindo.
start "" "%EXE%"

rem Fecha esta janela; o aplicativo continua rodando por conta propria.
popd
exit /b 0

:falhou
echo.
echo   A compilacao falhou. O texto do erro esta acima.
echo.
pause
popd
exit /b 1
