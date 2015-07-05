arp = ARP.new 1, 1, 6, 4
arp.senderHwAddr = [128, 48, 61, 53, 16, 87]
print arp.name
print "\n"
print arp.osiLayer
print "\n"
print arp.senderHwAddr
print "\n"
print arp.toBytes
print "\n"

arp2 = ARP.new 0, 0, 0, 0
arp2.fromBytes(arp.toBytes)
print arp2.toBytes
print "\n"
print arp2.toJson
print "\n"

arp3 = ARP.new 0, 0, 0, 0
arp3.fromJson(arp2.toJson)
print arp3.toBytes
print "\n"
