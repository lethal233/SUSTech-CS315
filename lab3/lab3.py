msgaddrstring = "0xbf903320"
msgaddr = int(msgaddrstring, 16)
RAaddr = msgaddr - 4
beginaddr = msgaddr + 16 * 4 + 26 * 4 + 12 + 8
print(hex(beginaddr))
high = beginaddr // (2**16)
# print(hex(high))
# print(hex(high << 16))
low = beginaddr - (high << 16)
print(hex(low))
x1 = high-22*8-12
x2 = low + 2**16 - high
print(hex(RAaddr))
print(x1, x2)
print(low-high)
