#!/bin/bash
set -e


# CONFIG
# ================================
STD="--std=08"
ANALYZE_OPTIONS='-frelaxed -Wno-shared -Wno-hide -P/home/cafecafe/Documents/OsvvmLibraries/sim/VHDL_LIBS/GHDL-4.1.0'
TOPLEVEL=tb_risc_v2_top
WAVE=wave.fst


# FUENTES (rutas relativas desde sim/GHDL/)
# ================================
VHDL_SOURCES="
../../src/rtl/pkg/risc_v2_pkg.vhd 
../../src/rtl/pkg/risc_v2_isa_pkg.vhd 
../../src/rtl/memory/risc_v2_memory.vhd 
../../src/rtl/fetch/risc_v2_pc.vhd 
../../src/rtl/fetch/risc_v2_if.vhd 
../../src/rtl/fetch/risc_v2_fetch.vhd 
../../src/rtl/execute/risc_v2_alu.vhd 
../../src/rtl/execute/risc_v2_excute.vhd 
../../src/rtl/decode/risc_v2_reg_file.vhd 
../../src/rtl/decode/risc_v2_decoder.vhd 
../../src/rtl/decode/risc_v2_decode.vhd 
../../src/rtl/risc_v2_core.vhd 
../../src/rtl/risc_v2_top.vhd 
../../src/verif/top/tb_risc_v2_top.vhd 
"

# ASSEMBLE
# ================================
printf "\033[32m[INFO] Assembling Code\033[0m\n"

cd ../../assembler
python build.py

# CLEAN PREVIOUS
# ================================
printf "\033[32m[INFO] Limpiando build anterior...\033[0m\n"
cd ./../sim/GHDL
rm -f work-obj08.cf $WAVE $TOPLEVEL || true


# ANALYZE
# ================================
printf "\033[32m[INFO] Analizando fuentes...\033[0m\n"
ghdl -i $STD $ANALYZE_OPTIONS $VHDL_SOURCES


# ELABORATE
# ================================
printf "\033[32m[INFO] Elaborando $TOPLEVEL...\033[0m\n"
ghdl -m $STD $ANALYZE_OPTIONS $TOPLEVEL

# ================================
# RUN
# ================================
printf "\033[32m[INFO] Ejecutando simulación...\033[0m\n"
ghdl -r $STD $ANALYZE_OPTIONS $TOPLEVEL --fst=$WAVE

printf "\033[32m[INFO] Simulación finalizada. Waveform: $WAVE\033[0m\n"

