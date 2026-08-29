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

    func testAnd() {
        let resultAdd = alu.add(0x80, 0x80, &flags)

        XCTAssertEqual(resultAdd, 0x00)
        XCTAssertTrue(flags.carry)
        XCTAssertTrue(flags.overflow)

        var result = alu.and(0x0C, 0x0A, &flags)
        XCTAssertEqual(result, 0x08)
        XCTAssertFalse(flags.zero)
        XCTAssertFalse(flags.sign)

        result = alu.and(0xFF, 0x0F, &flags)
        XCTAssertEqual(result, 0x0F)

        result = alu.and(0xFF, 0x80, &flags)
        XCTAssertTrue(flags.sign)

        result = alu.and(0x0C, 0x0A, &flags)
        XCTAssertFalse(flags.sign)

        result = alu.and(0x00, 0xFF, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.zero)

        result = alu.and(0x0C, 0x0A, &flags)
        XCTAssertEqual(result, 0x08)
        XCTAssertFalse(flags.zero)

        // FORÇAR
        result = alu.add(0xFF, 0x81, &flags)
        XCTAssertEqual(result, 0x80)
        XCTAssertTrue(flags.sign)
        XCTAssertFalse(flags.parity)
        XCTAssertFalse(flags.zero)
    }

    func testOr() {
        var result = alu.or(0x0C, 0x0A, &flags)
        XCTAssertEqual(result, 0x0E)

        result = alu.or(0xFF, 0x0F, &flags)
        XCTAssertEqual(result, 0xFF)

        result = alu.or(0x00, 0xFF, &flags)
        XCTAssertEqual(result, 0xFF)
    }

    func testXor() {
        var result = alu.xor(0x01, 0x03, &flags)
        XCTAssertEqual(result, 0x02)

        result = alu.xor(0x07, 0x0F, &flags)
        XCTAssertEqual(result, 0x08)
    }

    func testAND() {
        var lhs = UInt8(0xAA)
        var rhs = UInt8(0x55)
        

        var result = alu.and(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertFalse(flags.carry)
        XCTAssertFalse(flags.overflow)

        lhs = 0xCC
        rhs = 0xAA
        result = alu.and(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x88)

        lhs = 0xF0
        rhs = 0x0F
        result = alu.and(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x00)

        lhs = 0x08
        rhs = 0x0C
        result = alu.and(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x08)
    }

    func testOR() {
        var lhs = UInt8(0xAA)
        var rhs = UInt8(0x55)

        var result = alu.or(lhs, rhs, &flags)
        XCTAssertEqual(result, 0xFF)
        XCTAssertFalse(flags.zero)

        lhs = 0xCC
        rhs = 0xAA
        result = alu.or(lhs, rhs, &flags)
        XCTAssertEqual(result, 0xEE)

        lhs = 0xF0
        rhs = 0x0F
        result = alu.or(lhs, rhs, &flags)
        XCTAssertEqual(result, 0xFF)

        lhs = 0x08
        rhs = 0x0C
        result = alu.or(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x0C)

        XCTAssertEqual(alu.or(0x00, 0x00, &flags), 0x00)
        XCTAssertTrue(flags.zero)

        XCTAssertEqual(alu.or(0x00, 0x80, &flags), 0x80)
        XCTAssertTrue(flags.sign)

        XCTAssertEqual(alu.or(0x00, 0x01, &flags), 0x01)
        XCTAssertFalse(flags.sign)
    }

    func testXOR() {
        var lhs = UInt8(0xAA)
        var rhs = UInt8(0x55)

        var result = alu.xor(lhs, rhs, &flags)
        XCTAssertEqual(result, 0xFF)

        lhs = 0xCC
        rhs = 0xAA
        result = alu.xor(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x66)

        lhs = 0xF0
        rhs = 0x0F
        result = alu.xor(lhs, rhs, &flags)
        XCTAssertEqual(result, 0xFF)

        lhs = 0x08
        rhs = 0x0C
        result = alu.xor(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x04)

        lhs = 0x01
        rhs = 0x01

        result = alu.xor(lhs, rhs, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertEqual(alu.xor(0xAA, 0x55, &flags), 0xFF)
        XCTAssertEqual(alu.xor(0xCC, 0xAA, &flags), 0x66)
        XCTAssertEqual(alu.xor(0xF0, 0x0F, &flags), 0xFF)
        XCTAssertEqual(alu.xor(0x08, 0x0C, &flags), 0x04)
        XCTAssertFalse(flags.sign)
        XCTAssertEqual(alu.xor(0xFF, 0xFF, &flags), 0x00)
        XCTAssertEqual(alu.xor(0x00, 0x00, &flags), 0x00)
        XCTAssertTrue(flags.zero)
        XCTAssertEqual(alu.xor(0xFF, 0x7F, &flags), 0x80)
        XCTAssertTrue(flags.sign)
        XCTAssertEqual(alu.xor(0x00, 0xAA, &flags), 0xAA)
        XCTAssertTrue(flags.parity)
        XCTAssertEqual(alu.xor(0x00, 0x07, &flags), 0x07)
        XCTAssertFalse(flags.parity)
    }

    func testCarryAndOverflowWithXOR() {
        let result = alu.add(0x80, 0x80, &flags)
        XCTAssertEqual(result, 0x00)
        XCTAssertTrue(flags.carry)
        XCTAssertTrue(flags.overflow)

        XCTAssertEqual(alu.xor(0xAA, 0x55, &flags), 0xFF)
        XCTAssertFalse(flags.carry)
        XCTAssertFalse(flags.overflow)
    }
}