"""--====================================================================
--
--   /@@@@@@@  /@@@@@@  /@@@@@@   /@@@@@@        /@@    /@@  /@@@@@@
--  | @@__  @@|_  @@_/ /@@__  @@ /@@__  @@      | @@   | @@ /@@__  @@
--  | @@  \ @@  | @@  | @@  \__/| @@  \__/      | @@   | @@|__/  \ @@
--  | @@@@@@@/  | @@  |  @@@@@@ | @@            |  @@ / @@/  /@@@@@@/
--  | @@__  @@  | @@   \____  @@| @@             \  @@ @@/  /@@____/
--  | @@  \ @@  | @@   /@@  \ @@| @@    @@        \  @@@/  | @@
--  | @@  | @@ /@@@@@@|  @@@@@@/|  @@@@@@/         \  @/   | @@@@@@@@
--  |__/  |__/|______/ \______/  \______/           \_/    |________/
--
-- Description:
--
-- Author:       Mariano Olmos Martin
-- Mail  :       mariano.olmos@outlook.com
-- Date:         13/9/2025
-- Version:      v0.0
-- License: MIT License
--
-- Copyright (c) 2025 Mariano Olmos
--
-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this VHDL code and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject
-- to the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--======================================================================"""
import argparse, sys, json
from .assembler import assemble_lines, write_hex, AssemblerError
def main(argv=None):
    parser = argparse.ArgumentParser(
        prog="riscv-asm",
        description="Compilador/ensamblador mínimo de RISC‑V (RV32I) que genera init_file.hex (32 bits/ línea)."
    )
    parser.add_argument("-i","--input", help="Archivo .asm de entrada (si no se indica, lee de STDIN).")
    parser.add_argument("-o","--output", default="init_file.hex", help="Archivo de salida (por defecto: init_file.hex).")
    parser.add_argument("--base-address", default="0", help="Dirección base del programa (hex o dec).")
    parser.add_argument("--pad-words", type=int, default=None, help="Número total de palabras (se rellena con fill).")
    parser.add_argument("--fill", default="0x00000000", help="Valor de relleno (hex o dec).")
    parser.add_argument("--dump-symbols", help="Guarda la tabla de símbolos en JSON.")
    args = parser.parse_args(argv)
    def parse_num(s):
        s = s.lower();  return int(s,16) if s.startswith("0x") else int(s,10)
    try:
        base_addr = parse_num(args.base_address)
        fill_val = parse_num(args.fill)
    except ValueError:
        print("Error: base-address y fill deben ser números (dec o 0xHEX).", file=sys.stderr);  return 2
    if args.input:
        with open(args.input,"r",encoding="utf-8") as f:  lines = f.readlines()
    else:
        lines = sys.stdin.read().splitlines()
    try:
        words, labels = assemble_lines(lines, base_address=base_addr)
    except AssemblerError as e:
        print(f"Error de ensamblado: {e}", file=sys.stderr);  return 1
    write_hex(words, args.output, pad_words=args.pad_words, fill_value=fill_val)
    if args.dump_symbols:
        with open(args.dump_symbols, "w", encoding="utf-8") as f:  json.dump(labels, f, indent=2, ensure_ascii=False)
    print(f"OK → {args.output} generado con {len(words)} palabras.")
    if args.pad_words: print(f"Relleno hasta {args.pad_words} líneas con {fill_val:#010x}.")
    if args.dump_symbols: print(f"Símbolos guardados en {args.dump_symbols}.")
    return 0
if __name__ == "__main__":
    raise SystemExit(main())
