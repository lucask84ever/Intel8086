import XCTest
@testable import Intel8086

final class ALUTests: XCTestCase {

    var alu: ALU!
    var flags: Flags!

    override func setUp() {
        super.setUp()
        alu = ALU()
        flags = Flags(value: 0x00)
    }

    override func tearDown() {
        alu = nil
        flags = nil
        super.tearDown()
    }

    func testAddTwoBytes() {

        let result = alu.add(5, 3, &flags)

        XCTAssertFalse(flags.carry)
        XCTAssertEqual(result, 0x08)
    }

    func testOverflowUInt8() {

        let result = alu.add(UInt8.max, 1, &flags)
        XCTAssertTrue(flags.zero)
        XCTAssertTrue(flags.carry)
        XCTAssertEqual(result, 0x00)
    }

    func testSixtyFourUInt8() {

        let result = alu.add(0x40, 0x40, &flags)
        XCTAssertTrue(flags.sign)
        XCTAssertEqual(result, 0x80)
    }

    func testSignFlagTrue() {

        let result = alu.add(0x80, 1, &flags)
        XCTAssertTrue(flags.sign)
        XCTAssertEqual(result, 0x81)
    }

    func testSignFlagFalse() {

        let result = alu.add(0x40, 1, &flags)
        XCTAssertEqual(result, 0x41)
        XCTAssertFalse(flags.sign)
    }

    func testAddSetsParityFlagForEvenNumberOfOnes() {

        let result = alu.add(0x01, 0x02, &flags)

        XCTAssertEqual(result, 0x03)
        XCTAssertTrue(flags.parity)
    }

    func testAddSetsParityFlagForOddNumberOfOnes() {

        let result = alu.add(0x03, 0x04, &flags)

        XCTAssertEqual(result, 0x07)
        XCTAssertFalse(flags.parity)
    }

    func testAddSetsAuxiliaryCarry() {

        let result = alu.add(0x0F, 0x01, &flags)

        XCTAssertTrue(flags.auxiliary)
        XCTAssertEqual(result, 0x10)
    }

    func testAddDoesNotSetAuxiliaryCarry() {
        let result = alu.add(0x05, 0x01, &flags)

        XCTAssertFalse(flags.auxiliary)
        XCTAssertEqual(result, 0x06)
    }

    func testSignedOverflow() {
        let result = alu.add(0x01, 0x7F, &flags)

        XCTAssertEqual(result, 0x80)
        XCTAssertFalse(flags.carry)
        XCTAssertTrue(flags.overflow)
    }

    func testUnsignedOverflowWithCarry() {
        let result = alu.add(0x80, 0x80, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.carry)
        XCTAssertTrue(flags.overflow)
    }

    func testNoSignedOverflowWithDifferentSigns() {
        let result = alu.add(0x7f, 0xFF, &flags)

        XCTAssertEqual(result, 0x7E)
        XCTAssertFalse(flags.overflow)
    }

    func testOverflowReset() {
        var result = alu.add(0x7F, 0x01, &flags)
        XCTAssertEqual(result, 0x80)
        XCTAssertTrue(flags.overflow)
        result = alu.add(0x80, 0x80, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.overflow)
        result = alu.add(0x7F, 0xFF, &flags)
        XCTAssertEqual(result, 0x7E)
        XCTAssertFalse(flags.overflow)

    }
}