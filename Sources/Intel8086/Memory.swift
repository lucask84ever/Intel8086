struct Memory {
    private var data: [UInt8]

    subscript(address: Int) -> UInt8 {
        get {
            data[normalizeAddress(address)]
        }
        set {
            data[normalizeAddress(address)] = newValue
        }
    }

    init() {
        data = [UInt8](repeating: 0, count: 1024 * 1024)
    }

    mutating func writeWord(_ value: UInt16, at address: Int) {
        let low = UInt8(value & 0xFF)
        let high = UInt8(value >> 8)

        self[address] = low
        self[address + 1] = high 
    }

    func readWord(at address: Int) -> UInt16 {
        let low = self[address]
        let high = self[address + 1]

        return (UInt16(high) << 8) | UInt16(low)
    }

    private func normalizeAddress(_ address: Int) -> Int {
        address & 0xFFFFF
    }
}