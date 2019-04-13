@echo off
PUSHD "%~dp0"
REM Copia da pasta de projeto para o HW Project
ROBOCOPY "Development\Dumb_Communications_Module" "..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon\Dumb_Communications_Module" /MIR /E /R:0 /W:0 /NJH /NJS
ROBOCOPY "Development" "..\..\G3U_HW_V02_2GB\Hardware_Project\Avalon" "COMM_Pedreiro_v1_01_hw.tcl" /R:0 /W:0 /NJH /NJS
REM PAUSE
