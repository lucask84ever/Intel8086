
struct ALU {
    func add(_ lhs: UInt8, _ rhs: UInt8, _ flags: inout Flags) -> UInt8 {
        let result = UInt16(lhs) + UInt16(rhs)

        let value = UInt8(result & 0x0FF)

        let lhsSign = hasSignBit(lhs)
        let rhsSign = hasSignBit(rhs)
        let resultSign = hasSignBit(value)
        
        flags.overflow = lhsSign == rhsSign && resultSign != lhsSign
        flags.parity = hasEvenParity(value)
        flags.carry = result > UInt16(UInt8.max)
        flags.zero = value == 0
        flags.sign = (value & 0x80) != 0
        flags.auxiliaryCarry = (UInt16(lhs & 0x0F) + UInt16(rhs & 0x0F) > 0x0F)

        return value
    }

    func sub(_ lhs: UInt8, _ rhs: UInt8, _ flags: inout Flags) -> UInt8 {
        let result = truncatingSub(lhs, rhs)
        let value = UInt8(result & 0x00FF)

        let lhsSign = hasSignBit(lhs)
        let rhsSign = hasSignBit(rhs)
        let resultSign = hasSignBit(value)

        flags.carry = lhs < rhs
        flags.zero = value == 0x00
        flags.sign = (value & 0x80) != 0
        flags.parity = hasEvenParity(value)
        flags.overflow = lhsSign != rhsSign && resultSign != lhsSign
        flags.auxiliaryCarry = (lhs & 0x0F) < (rhs & 0x0F)
        return value
    }

    func and(_ lhs: UInt8, _ rhs: UInt8, _ flags: inout Flags) -> UInt8 {
        let value = lhs & rhs
        flags.carry = false
        flags.overflow = false
        flags.parity = hasEvenParity(value)
        flags.sign = (value & 0x80) != 0
        flags.zero = value == 0
        return value
    }

    func or(_ lhs: UInt8, _ rhs: UInt8, _ flags: inout Flags) -> UInt8 {
        let value = lhs | rhs
        flags.carry = false
        flags.overflow = false
        flags.zero = value == 0
        flags.sign = (value & 0x80) != 0
        flags.parity = hasEvenParity(value)
        return value
    }

    func xor(_ lhs: UInt8, _ rhs: UInt8, _ flags: inout Flags) -> UInt8 {
        let value = lhs ^ rhs
        flags.carry = false
        flags.overflow = false
        flags.zero = value == 0
        flags.parity = hasEvenParity(value)
        flags.sign = (value & 0x80) != 0
        return value
    }

    func not(_ value: UInt8) -> UInt8 {
        return ~value
    }

    private func hasEvenParity(_ value: UInt8) -> Bool {
        var value = value
        var count = 0

        for _ in 0..<8 {
            count += Int(value & 1)
            value >>= 1
        }

        return count % 2 == 0
    }

    private func truncatingSub(_ lhs: UInt8, _ rhs: UInt8) -> UInt8 {
        let result: UInt16
        if lhs >= rhs {
            result = UInt16(lhs) - UInt16(rhs)
        } else {
            result = 0x100 + UInt16(lhs) - UInt16(rhs)
        }
        return UInt8(result)
    }

    private func hasSignBit(_ value: UInt8) -> Bool {
        return (value & 0x80) != 0
    }
}