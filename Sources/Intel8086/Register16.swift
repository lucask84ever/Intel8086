struct Register16 {
    var low: UInt8
    var high: UInt8

    var value: UInt16 {
        set {
            self.high = UInt8(newValue >> 8)
            self.low = UInt8(newValue & 0xFF)
        }

        get {
            return (UInt16(high) << 8 | UInt16(low))
        }
    }

    init(low: UInt8, high: UInt8) {
        self.low = low
        self.high = high
    }

    init(value: UInt16) {
        self.high = UInt8(value >> 8)
        self.low = UInt8(value & 0xFF)
    }
}