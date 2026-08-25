struct Intel8086 {

    var physicalAddress: UInt32  {
        get {
            return  UInt32(registers.cs.value) << 4 + UInt32(registers.ip.value)
        }
    }

    var registers = Registers()

}