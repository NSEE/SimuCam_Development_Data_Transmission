@ECHO off
PUSHD "%~dp0"
REM Executa os batch files responsaveis pelo update de cada módulo o Hw Project
START cmd /c "..\FPGA_Developments\Dumb_COM_Module\UpdateDcom100Hw.bat"
REM Adicionar novos Hw sempre que forem criados
REM PAUSE
