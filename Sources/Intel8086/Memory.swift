struct Memory {
    private var data: [UInt8]

    subscript(address: Int) -> UInt8 {
        get {
            data[address]
        }
        set {
            data[address] = newValue
        }
    }

    init() {
        data = [UInt8](repeating: 0, count: 1024 * 1024)
    }

    mutating func writeWord(_ value: UInt16, at: Int) {
        let low = UInt8(value & 0xff)
        let high = UInt8(value >> 8)

        data[at] = low
        data[at + 1] = high
    }

    func readWord(at: Int) -> UInt16 {
        return UInt16(data[at + 1] << 8) | UInt16(data[at])
    }
}