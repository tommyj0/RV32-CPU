`define LOAD    7'b0000011
`define FENCE   7'b0001111
`define MATHI   7'b0010011
`define AUIPC   7'b0010111
`define MATHIW  7'b0011011 // ignore in 32bit
`define STORE   7'b0100011
`define MATHR   7'b0110011
`define LUI     7'b0110111
`define MATHRW  7'b0111011 // ignore in 32bit
`define BRANCH  7'b1100011
`define JALR    7'b1100111
`define JAL     7'b1101111
`define CSR     7'b1110011