import XCTest
@testable import Intel8086

final class Register16Tests: XCTestCase {

    func testValueSetsHighAndLow() {
        let register = Register16(low: 0x12, high: 0x34)

        XCTAssertEqual(register.high, 0x34)
        XCTAssertEqual(register.low, 0x12)
        XCTAssertEqual(register.value, 0x3412)
    }

    func testChangeHighValue() {
        var register = Register16(low: 0x12, high: 0x34)
        register.high = 0x56

        XCTAssertEqual(register.high, 0x56)
        XCTAssertEqual(register.low, 0x12)
        XCTAssertEqual(register.value, 0x5612)
    }

    func testChangeLowValue() {
        var register = Register16(low: 0x12, high: 0x34)
        register.low = 0x56

        XCTAssertEqual(register.high, 0x34)
        XCTAssertEqual(register.low, 0x56)
        XCTAssertEqual(register.value, 0x3456)
    }

    func testChangeRegisterValue() {
        var register = Register16(low: 0x12, high: 0x34)
        register.value = 0x5678

        XCTAssertEqual(register.high, 0x56)
        XCTAssertEqual(register.low, 0x78)
        XCTAssertEqual(register.value, 0x5678)
    }

    func testRegisterZero() {
        let register = Register16(low: 0x00, high: 0x00)
        XCTAssertEqual(register.value, 0x0000)
    }

    func testRegisterFfff() {
        let register = Register16(low: 0xff, high: 0xff)
        XCTAssertEqual(register.value, 0xffff)
    }

    func testRegisterMax() {
        let register = Register16(low: UInt8.max, high: UInt8.max)
        XCTAssertEqual(register.value, UInt16.max)
    }

    func testRegisterMin() {
        let register = Register16(low: 0, high: 0)
        XCTAssertEqual(register.value, 0)
    }

    func testLowMaxHighMin() {
        let register = Register16(low: UInt8.max, high: 0)
        XCTAssertEqual(register.value, 0x00FF)
    }

    func testHighMaxLowMin() {
        let register = Register16(low: 0, high: UInt8.max)
        XCTAssertEqual(register.value, 0xFF00)
    }

    func testAllBitsSet() {
        let register = Register16(low: 0xFF, high: 0xFF)

        XCTAssertEqual(register.value, 0xFFFF)
        XCTAssertEqual(register.high, 0xFF)
        XCTAssertEqual(register.low, 0xFF)
    }

    func testAllBitsClear() {
        let register = Register16(low: 0x00, high: 0x00)

        XCTAssertEqual(register.value, 0x0000)
        XCTAssertEqual(register.high, 0x00)
        XCTAssertEqual(register.low, 0x00)
    }
}