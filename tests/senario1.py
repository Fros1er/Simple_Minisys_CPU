a = input()
b = input()

a = int(a, 16)
b = int(b, 16)


def int32(x):
    if x > 0xFFFFFFFF:
        raise OverflowError
    if x > 0x7FFFFFFF:
        x = int(0x100000000-x)
        if x < 2147483648:
            return -x
        else:
            return -2147483648
    return x


print(hex(a & b))
print(hex(a | b))
print(hex(a ^ b))
print(hex(a << b))
print(hex(a >> b))
print(hex((int32(a) >> b) & ((1 << 32) - 1)))
