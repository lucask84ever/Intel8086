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


// ADD
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

        var result = alu.add(0x80, 1, &flags)
        XCTAssertTrue(flags.sign)
        XCTAssertEqual(result, 0x81)
        // second operation
        result = alu.add(0x40, 1, &flags)
        XCTAssertFalse(flags.sign)
        XCTAssertEqual(result, 0x41)
    }

    func testSignFlagFalse() {

        let result = alu.add(0x40, 1, &flags)
        XCTAssertEqual(result, 0x41)
        XCTAssertFalse(flags.sign)
    }

    func testAddSetsParityFlagForEvenNumberOfOnes() {

        var result = alu.add(0x01, 0x02, &flags)

        XCTAssertEqual(result, 0x03)
        XCTAssertTrue(flags.parity)

        // second operation
        result = alu.add(0x03, 0x04, &flags)

        XCTAssertEqual(result, 0x07)
        XCTAssertFalse(flags.parity)
    }

    func testAddSetsParityFlagForOddNumberOfOnes() {

        let result = alu.add(0x03, 0x04, &flags)

        XCTAssertEqual(result, 0x07)
        XCTAssertFalse(flags.parity)
    }

    func testAddSetsauxiliaryCarryCarry() {

        var result = alu.add(0x0F, 0x01, &flags)

        XCTAssertTrue(flags.auxiliaryCarry)
        XCTAssertEqual(result, 0x10)

        // second operation
        result = alu.add(0x05, 0x01, &flags)

        XCTAssertFalse(flags.auxiliaryCarry)
        XCTAssertEqual(result, 0x06)
    }

    func testAddDoesNotSetauxiliaryCarryCarry() {
        let result = alu.add(0x05, 0x01, &flags)

        XCTAssertFalse(flags.auxiliaryCarry)
        XCTAssertEqual(result, 0x06)
    }

    func testSignedOverflow() {
        let result = alu.add(0x01, 0x7F, &flags)

        XCTAssertEqual(result, 0x80)
        XCTAssertTrue(flags.overflow)
        XCTAssertFalse(flags.carry)
    }

    func testSignedOverflowAlsoSetsCarry() {
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

        // second operation
        result = alu.add(0x80, 0x80, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.overflow)

        // third operation
        result = alu.add(0x7F, 0xFF, &flags)
        XCTAssertEqual(result, 0x7E)
        XCTAssertFalse(flags.overflow)

    }

    // SUB
    func testSubTwoBytes() {
        let result = alu.sub(0x05, 0x03, &flags)
        XCTAssertEqual(result, 0x02)
        XCTAssertFalse(flags.carry)
    }

    func testSubWrap() {
        var result = alu.sub(0x00, 0x01, &flags)
        XCTAssertEqual(result, 0xFF)
        XCTAssertTrue(flags.carry)
        XCTAssertTrue(flags.sign)

        result = alu.sub(0x04, 0x03, &flags)
        XCTAssertEqual(result, 0x01)
        XCTAssertFalse(flags.sign)
        XCTAssertFalse(flags.carry)
    }

    func testResultZero() {
        var result = alu.sub(0x05, 0x05, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.zero)

        result = alu.sub(0x03, 0x05, &flags)
        XCTAssertEqual(result, 0xFE)
        XCTAssertFalse(flags.zero)

        result = alu.sub(0xFF, 0xFF, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.zero)
    }

        func testSubSetsParityFlagForEvenNumberOfOnes() {

        var result = alu.sub(0x05, 0x02, &flags)

        XCTAssertEqual(result, 0x03)
        XCTAssertTrue(flags.parity)

        // second operation
        result = alu.sub(0x0A, 0x03, &flags)

        XCTAssertEqual(result, 0x07)
        XCTAssertFalse(flags.parity)
    }

    func testCarrySignAndOverflow() {
        var result = alu.sub(0x80, 0x01, &flags)

        XCTAssertEqual(result, 0x7F)
        XCTAssertFalse(flags.carry)
        XCTAssertFalse(flags.sign)
        XCTAssertTrue(flags.overflow)

        result = alu.sub(0x01, 0x80, &flags)
        XCTAssertEqual(result, 0x81)
        XCTAssertTrue(flags.carry)
        XCTAssertTrue(flags.sign)
        XCTAssertTrue(flags.overflow)

        result = alu.sub(0x7F, 0x01, &flags)
        XCTAssertEqual(result, 0x7E)
        XCTAssertFalse(flags.overflow)
    }

    func testSubauxiliaryCarry() {
        var result = alu.sub(0x10, 0x01, &flags)

        XCTAssertEqual(result, 0x0F)
        XCTAssertTrue(flags.auxiliaryCarry)
        XCTAssertFalse(flags.carry)

        result = alu.sub(0x00, 0x01, &flags)
        XCTAssertEqual(result, 0xFF)
        XCTAssertTrue(flags.auxiliaryCarry)
        XCTAssertTrue(flags.carry)
    }
}