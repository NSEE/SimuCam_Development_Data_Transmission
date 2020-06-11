@ECHO off
PUSHD "%~dp0"
REM Executa os batch files responsaveis pelo update de cada módulo o Hw Project
START cmd /c "..\FPGA_Developments\Dumb_COM_Module_v2\Development\UpdateDcom200Hw.bat"
START cmd /c "..\FPGA_Developments\RMAP_Memory_Subunit_Area\Development\UpdateSRMe100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Channel\Development\UpdateSpwc100Hw.bat
START cmd /c "..\FPGA_Developments\SpaceWire_Glutton\Development\UpdateSpwGluttonHw.bat
START cmd /c "..\FPGA_Developments\Sync\Development\UpdateSyncHw.bat"
REM Adicionar novos Hw sempre que forem criados
REM PAUSE
