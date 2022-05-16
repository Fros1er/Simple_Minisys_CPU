-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Mon May 16 19:38:57 2022
-- Host        : DESKTOP-AK5GC2F running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub d:/code/mips_cpu/mips_cpu.srcs/sources_1/ip/cpuclk/cpuclk_stub.vhdl
-- Design      : cpuclk
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpuclk is
  Port ( 
    clk : out STD_LOGIC;
    uart_clk : out STD_LOGIC;
    sys_clk : in STD_LOGIC
  );

end cpuclk;

architecture stub of cpuclk is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,uart_clk,sys_clk";
begin
end;
