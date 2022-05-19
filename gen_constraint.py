# pins = "N19 N20 M20 K13 K14 M13 L13 K17 J17 L14 L15 L16 K16 M15 M16 M17"
# pins = "W4 R4 T4 T5 U5 W6 W5 U6 V5 R6 T6 Y6 AA6 V7 AB7 AB6"
# pins = "A18 A20 B20 E18 F18 D19 E19 C19 F15 F13 F14 F16 E17 C14 C15 E13"
pins = "N2 M6 M5 P6 N5 J16 K18 K19"

# num = 0
# for pin in pins.split(" "):
#     print("set_property PACKAGE_PIN %s [get_ports {gpio_e[%d]}]" % (pin, num))
#     print("set_property IOSTANDARD LVCMOS33 [get_ports {gpio_e[%d]}]" % num)
#     print("set_property DRIVE 12 [get_ports {gpio_e[%d]}]" % num)
#     print("set_property SLEW SLOW [get_ports {gpio_e[%d]}]" % num)
#     num += 1

for i in range(0, 16):
    print("set_property PULLTYPE PULLUP [get_ports {gpio_f[%d]}]" % i)