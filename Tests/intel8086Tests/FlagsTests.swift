import XCTest
@testable import Intel8086

final class FlagsTests: XCTestCase {

    func testCarryFlagUsesBitZero() {
        var flags = Flags(value: 0)

        flags.carry = true

        XCTAssertEqual(flags.value, 0b0000_0000_0000_0001)
    }

    func testCarryFlagCanBeCleared() {
        var flags = Flags(value: 0x0001)

        flags.carry = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingCarryDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.carry = false
        XCTAssertEqual(flags.value, 0xFFFE)
    }

    func testChangeParityFlag() {
        var flags = Flags(value: 0x0000)

        flags.parity = true
        XCTAssertEqual(flags.value, 0x0004)
    }

    func testParityCanBeCleared() {
        var flags = Flags(value: 0x0004)

        flags.parity = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingParityDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.parity = false
        XCTAssertEqual(flags.value, 0xFFFB)
    }

    func testChangeAuxiliaryCarryFlag() {
        var flags = Flags(value: 0x0000)

        flags.auxiliaryCarry = true
        XCTAssertEqual(flags.value, 0x0010)
    }

    func testAuxiliaryCarryCanBeCleared() {
        var flags = Flags(value: 0x0010)

        flags.auxiliaryCarry = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingAuxiliaryCarryDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.auxiliaryCarry = false
        XCTAssertEqual(flags.value, 0xFFEF)
    }

    func testChangeZeroFlag() {
        var flags = Flags(value: 0x0000)

        flags.zero = true
        XCTAssertEqual(flags.value, 0x0040)
    }

    func testZeroCanBeCleared() {
        var flags = Flags(value: 0x0040)

        flags.zero = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingZeroDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.zero = false
        XCTAssertEqual(flags.value, 0xFFBF)
    }

    func testChangeSignFlag() {
        var flags = Flags(value: 0x0000)

        flags.sign = true
        XCTAssertEqual(flags.value, 0x0080)
    }

    func testSignCanBeCleared() {
        var flags = Flags(value: 0x0080)

        flags.sign = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingSignDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.sign = false
        XCTAssertEqual(flags.value, 0xFF7F)
    }

    func testChangeTrapFlag() {
        var flags = Flags(value: 0x0000)

        flags.trap = true
        XCTAssertEqual(flags.value, 0x0100)
    }

    func testTrapCanBeCleared() {
        var flags = Flags(value: 0x0100)

        flags.trap = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingTrapDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.trap = false
        XCTAssertEqual(flags.value, 0xFEFF)
    }

    func testChangeInterruptFlag() {
        var flags = Flags(value: 0x0000)

        flags.interrupt = true
        XCTAssertEqual(flags.value, 0x0200)
    }

    func testInterruptCanBeCleared() {
        var flags = Flags(value: 0x0200)

        flags.interrupt = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingInterruptDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.interrupt = false
        XCTAssertEqual(flags.value, 0xFDFF)
    }

    func testChangeDirectionFlag() {
        var flags = Flags(value: 0x0000)

        flags.direction = true
        XCTAssertEqual(flags.value, 0x0400)
    }

    func testDirectionCanBeCleared() {
        var flags = Flags(value: 0x0400)

        flags.direction = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingDirectionDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.direction = false
        XCTAssertEqual(flags.value, 0xFBFF)
    }

    func testChangeOverflowFlag() {
        var flags = Flags(value: 0x0000)

        flags.overflow = true
        XCTAssertEqual(flags.value, 0x0800)
    }

    func testOverflowCanBeCleared() {
        var flags = Flags(value: 0x0800)

        flags.overflow = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testChangingOverflowDoesNotChangeOtherFlags() {
        var flags = Flags(value: 0xFFFF)

        flags.overflow = false
        XCTAssertEqual(flags.value, 0xF7FF)
    }

    func testAllFlagsDisabled() {
        var flags = Flags(value:0x0FD5)

        flags.carry = false
        flags.parity = false
        flags.auxiliaryCarry = false
        flags.zero = false
        flags.sign = false
        flags.trap = false
        flags.interrupt = false
        flags.direction = false
        flags.overflow = false
        XCTAssertEqual(flags.value, 0x0000)
    }

    func testAllFlagsEnabled() {
        var flags = Flags(value: 0)

        flags.carry = true
        flags.parity = true
        flags.auxiliaryCarry = true
        flags.zero = true
        flags.sign = true
        flags.trap = true
        flags.interrupt = true
        flags.direction = true
        flags.overflow = true
        XCTAssertEqual(flags.value, 0x0FD5)
    }
}