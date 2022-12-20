# Polar Codes

VHDL code describing the logic for a combinational Successive-Cancellation decoder for Polar Codes. A recursive expression is used to generate the required modules. 
A combinational polar encoder is also included, as it is a fundamental component of the decoder.

See pkg_polar_codec.vhd to find constants used throughout the files.

See https://doi.org/10.1016/j.micpro.2021.104264 and https://doi.org/10.1109/RPIC.2019.8882149 for more information on the architecture and its components.

Decoder and encoder were synthesized and tested on an Intel Cyclone V FPGA.
