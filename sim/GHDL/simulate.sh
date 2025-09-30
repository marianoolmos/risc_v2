#!/bin/bash
set -e


# CONFIG
# ================================
STD="--std=08"
ANALYZE_OPTIONS='-frelaxed -P"/home/cafecafe/Documents/OsvvmLibraries/sim/VHDL_LIBS/GHDL-4.1.0/"'
TOPLEVEL=tb_risc_v2_top
WAVE=wave.ghw


# FUENTES (rutas relativas desde sim/GHDL/)
# ================================
VHDL_SOURCES="
../../src/rtl/pkg/risc_v2_pkg.vhd
../../src/rtl/risc_v2_reg_file.vhd
../../src/rtl/risc_v2_memory.vhd
../../src/rtl/risc_v2_fetch.vhd
../../src/rtl/pkg/risc_v2_isa_pkg.vhd
../../src/rtl/risc_v2_decoder.vhd
../../src/rtl/risc_v2_alu.vhd
../../src/rtl/risc_v2_dec_exe.vhd
../../src/rtl/risc_v2_core.vhd
../../src/rtl/risc_v2_top.vhd
../../src/verif/top/tb_risc_v2_top.vhd
"


# CLEAN PREVIOUS
# ================================
echo "[INFO] Limpiando build anterior..."
rm -f work-obj08.cf $WAVE $TOPLEVEL || true


# ANALYZE
# ================================
echo "[INFO] Analizando fuentes..."
ghdl -i $STD $ANALYZE_OPTIONS $VHDL_SOURCES


# ELABORATE
# ================================
echo "[INFO] Elaborando $TOPLEVEL..."
ghdl -m $STD $ANALYZE_OPTIONS $TOPLEVEL

# ================================
# RUN
# ================================
echo "[INFO] Ejecutando simulación..."
ghdl -r $STD $ANALYZE_OPTIONS $TOPLEVEL --wave=$WAVE

echo "[INFO] Simulación finalizada. Waveform: $WAVE"

