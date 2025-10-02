
import subprocess, sys, os, pathlib
here = pathlib.Path(__file__).parent
asm = here/"examples"/"demo.asm"
out = here/"init_file.hex"
cmd = [sys.executable, "-m", "riscv_assembler.cli", "-i", str(asm), "-o", str(out), "--pad-words", "26"]
print("Ejecutando:", " ".join(cmd))
subprocess.check_call(cmd)
print("Listo:", out)
