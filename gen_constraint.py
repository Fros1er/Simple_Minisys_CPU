# pins = "K17 L13 M13 K14 K13 M20 N20 N19 M17 M16 M15 K16 L16 L15 L14 J17"
pins = "Y9 W9 Y7 Y8 AB8 AA8 V8 V9 AB6 AB7 V7 AA6 Y6 T6 R6 V5"
# pins = "A18 A20 B20 E18 F18 D19 E19 C19 F15 F13 F14 F16 E17 C14 C15 E13"
# pins = "N2 M6 M5 P6 N5 J16 K18 K19"

name = 'b'

num = 0
for pin in pins.split(" "):
    print("set_property PACKAGE_PIN %s [get_ports {gpio_%s_out[%d]}]" % (pin, name, num))
    print("set_property IOSTANDARD LVCMOS33 [get_ports {gpio_%s_out[%d]}]" % (name, num))
    print("set_property DRIVE 12 [get_ports {gpio_%s_out[%d]}]" % (name, num))
    print("set_property SLEW SLOW [get_ports {gpio_%s_out[%d]}]" % (name, num))
    num += 1

# for i in range(0, 16):
#     print("set_property PULLTYPE PULLUP [get_ports {gpio_%s_out[%d]}]" % (name, i))
#     print("set_property IOSTANDARD LVCMOS33 [get_ports {gpio_%s_out[%d]}]" % (name, i))