from vunit import VUnit
from os import environ

# Set VUnit simulator to NVC via env var (needed if GHDL is also installed)
environ["VUNIT_SIMULATOR"] = "nvc"
# Create a VUnit project instance from command line arguments
vu = VUnit.from_argv()

# Add VUnit's built-in utilities for checking, logging, communication...
vu.add_vhdl_builtins()
...
# Add source files and configure tests
...
# Run tests
vu.main()
