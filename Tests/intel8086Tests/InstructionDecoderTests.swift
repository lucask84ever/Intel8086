import XCTest
@testable import Intel8086

final class InstructionDecoderTests: XCTestCase {

    func testDirectionZeroWidthZero() {
        let decoder = InstructionDecoder(bytes: [0x00])
        XCTAssertEqual(decoder.opcode, 0b000000)
        XCTAssertEqual(decoder.direction, 0x00)
        XCTAssertEqual(decoder.width, 0x00)
    }

    func testDecodeOpcode() {
        let decoder = InstructionDecoder(bytes: [0x01])

        XCTAssertEqual(decoder.opcode, 0b000000)
        XCTAssertEqual(decoder.direction, 0x00)
        XCTAssertEqual(decoder.width, 0x01)
    }

    func testDecodeTwo() {
        let decoder = InstructionDecoder(bytes: [0x02])

        XCTAssertEqual(decoder.opcode, 0b000000)
        XCTAssertEqual(decoder.direction, 0x01)
        XCTAssertEqual(decoder.width, 0x00)
    }
    func testDecodeInstruction() {
        let decoder = InstructionDecoder(bytes: [0x03])

        XCTAssertEqual(decoder.opcode, 0b000000)
        XCTAssertEqual(decoder.direction, 0x01)
        XCTAssertEqual(decoder.width, 0x01)
    }

    func testDecodeOpcode1() {
        let decoder = InstructionDecoder(bytes: [0x01, 0xD8])

        XCTAssertEqual(decoder.opcode, 0b000000)
        XCTAssertEqual(decoder.direction, 0x00)
        XCTAssertEqual(decoder.width, 0x01)

        XCTAssertEqual(decoder.modRM.mod, 0b11)
        XCTAssertEqual(decoder.modRM.reg, 0b011)
        XCTAssertEqual(decoder.modRM.rm, 0b000)
    }

    func testDecodeInstruction1() {
        let decoder = InstructionDecoder(bytes: [0x03, 0xFF])

        XCTAssertEqual(decoder.opcode, 0b000000)
        XCTAssertEqual(decoder.direction, 0x01)
        XCTAssertEqual(decoder.width, 0x01)

        XCTAssertEqual(decoder.modRM.mod, 0b11)
        XCTAssertEqual(decoder.modRM.reg, 0b111)
        XCTAssertEqual(decoder.modRM.rm, 0b111)
    }

    func testDirectionZeroWidthZero1() {
        let decoder = InstructionDecoder(bytes: [0x09, 0x00])
        XCTAssertEqual(decoder.opcode, 0b000010)
        XCTAssertEqual(decoder.direction, 0x00)
        XCTAssertEqual(decoder.width, 0x01)

        XCTAssertEqual(decoder.modRM.mod, 0b00)
        XCTAssertEqual(decoder.modRM.reg, 0b000)
        XCTAssertEqual(decoder.modRM.rm, 0b000)

    }
    func testDirection() {
        let decoder = InstructionDecoder(bytes: [0x0A, 0x80])

        XCTAssertEqual(decoder.opcode, 0b000010)
        XCTAssertEqual(decoder.direction, 0x01)
        XCTAssertEqual(decoder.width, 0x00)

        XCTAssertEqual(decoder.modRM.mod, 0b10)
        XCTAssertEqual(decoder.modRM.reg, 0b000)
        XCTAssertEqual(decoder.modRM.rm, 0b000)
    }

    func testLengthWithDisp8() {
        let decoder = InstructionDecoder(bytes: [0x8B, 0x47, 0xF8])

        XCTAssertEqual(decoder.length, 3)
    }

    func testLengthWithDisp16() {
        let decoder = InstructionDecoder(bytes: [0x8B, 0x86, 0x34, 0x12])

        XCTAssertEqual(decoder.length, 4)
    }

    func testLengthWithDirectDisp16() {
        let decoder = InstructionDecoder(bytes: [0xC7, 0x06, 0x34, 0x12, 0x78, 0x56])
        XCTAssertEqual(decoder.length, 6)
    }

    func testLengthWithImmediate16() {
        let decoder = InstructionDecoder(bytes: [0xB8, 0x34, 0x12])

        XCTAssertEqual(decoder.length, 3)
    }

    func testLengthWithImmediate8() {
        let decoder = InstructionDecoder(bytes: [0xB0, 0x34])
        XCTAssertEqual(decoder.length, 2)
    }

    func testLengthWithImmediate16CX() {
        let decoder = InstructionDecoder(bytes: [0xB9, 0x34, 0x12])
        XCTAssertEqual(decoder.length, 3)
    }

    func testImmediateWidth() {
        let decoder8 = InstructionDecoder(bytes: [0xB0, 0x34])
        let decoder16 = InstructionDecoder(bytes: [0xB8, 0x34, 0x12])

        XCTAssertEqual(decoder8.width, 0)
        XCTAssertEqual(decoder16.width, 1)
    }

    func testLengthWithImmediate16DI() {
        let decoder = InstructionDecoder(bytes: [0xBF, 0x34, 0x12])
        XCTAssertEqual(decoder.length, 3)
    }

    func testLengthWithDirectDisp16AndImmediate16() {
        let decoder = InstructionDecoder(bytes: [0xC7, 0x06, 0x34, 0x12, 0x78, 0x56])
        XCTAssertEqual(decoder.length, 6)
    }

    func testLengthWithImmediate8AndModRM() {
        let decoder = InstructionDecoder(
            bytes: [0xC6, 0x06, 0x34, 0x12, 0x78]
        )

        XCTAssertEqual(decoder.length, 5)
    }

    func testImmediateLengthWithImmediate() {
        let decoder = InstructionDecoder(bytes: [
            0x89, 0xD8
        ])

        XCTAssertEqual(decoder.immediateLength, 0)
    }

    func testImmediateLengthWithImmediate8() {
        let decoder = InstructionDecoder(bytes: [
            0xB0, 0x12
        ])

        XCTAssertEqual(decoder.immediateLength, 1)
    }

    func testImmediateLengthWithImmediate16() {
        let decoder = InstructionDecoder(bytes: [
            0xB8, 0x34, 0x12
        ])

        XCTAssertEqual(decoder.immediateLength, 2)
    }

    func testImmediateLengthWithImmediate8ToRegisterMemory() {
        let decoder = InstructionDecoder(bytes: [
            0xC6, 0x06, 0x12, 0x34
        ])

        XCTAssertEqual(decoder.immediateLength, 1)
    }

    func testImmediateLengthWithImmediate16ToRegisterMemory() {
        let decoder = InstructionDecoder(bytes: [
            0xC7, 0x06, 0x34, 0x12, 0x78, 0x56
        ])

        XCTAssertEqual(decoder.immediateLength, 2)
    }

    func testDisplacementLengthWithoutDisplacement() {
        let decoder = InstructionDecoder(bytes: [
            0x8B, 0x07
        ])

        XCTAssertEqual(decoder.displacementLength, 0)
    }

    func testDisplacementLengthWithDirectAddress() {
        let decoder = InstructionDecoder(bytes: [
            0x8B, 0x06, 0x34, 0x12
        ])

        XCTAssertEqual(decoder.displacementLength, 2)
    }

    func testDisplacementLengthWithDisplacement8() {
        let decoder = InstructionDecoder(bytes: [
            0x8b, 0x40, 0x12
        ])

        XCTAssertEqual(decoder.displacementLength, 1)
    }

    func testDisplacementLengthWithDisplacement16() {
        let decoder = InstructionDecoder(bytes: [
            0x8b, 0x80, 0x34, 0x12
        ])

        XCTAssertEqual(decoder.displacementLength, 2)
    }

    func testDisplacementLengthWithRegisterMode() {
        let decoder = InstructionDecoder(bytes: [
            0x8B, 0xC0
        ])

        XCTAssertEqual(decoder.displacementLength, 0)
    }

    func testImmediateToRegisterDoesNotHaveModRM() {
        let decoder = InstructionDecoder(bytes: [
            0xB0, 0x12
        ])

        XCTAssertFalse(decoder.hasModRM)
    }

    func testWidthForMovImmediateToRegister() {
        XCTAssertEqual(InstructionDecoder(bytes: [0xB0]).width, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0xB8]).width, 1)
    }

    func testWidthForMovRegisterMemoryToFromRegister() {
        XCTAssertEqual(InstructionDecoder(bytes: [0x88]).width, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0x89]).width, 1)
        XCTAssertEqual(InstructionDecoder(bytes: [0x8A]).width, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0x8B]).width, 1)

        
        XCTAssertEqual(InstructionDecoder(bytes: [0xB0]).width, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0xB8]).width, 1)

        XCTAssertEqual(InstructionDecoder(bytes: [0xC6]).width, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0xC7]).width, 1)
    }

    func testDirectionForMovRegisterMemoryToFromRegister() {
        XCTAssertEqual(InstructionDecoder(bytes: [0x88]).direction, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0x89]).direction, 0)
        XCTAssertEqual(InstructionDecoder(bytes: [0x8A]).direction, 1)
        XCTAssertEqual(InstructionDecoder(bytes: [0x8B]).direction, 1)
    }

    func testOpcodeForMovRegisterMemoryToFromRegister() {
        XCTAssertEqual(InstructionDecoder(bytes: [0x88]).opcode, 0b100010)
        XCTAssertEqual(InstructionDecoder(bytes: [0x89]).opcode, 0b100010)
        XCTAssertEqual(InstructionDecoder(bytes: [0x8A]).opcode, 0b100010)
        XCTAssertEqual(InstructionDecoder(bytes: [0x8B]).opcode, 0b100010)
    }

    func testOpCodeForMovImmediateToRegister() {
        XCTAssertEqual(InstructionDecoder(bytes: [0xB0]).opcode, 0b1011)
        XCTAssertEqual(InstructionDecoder(bytes: [0xB8]).opcode, 0b1011)
        XCTAssertEqual(InstructionDecoder(bytes: [0xC6]).opcode, 0b1100011)
        XCTAssertEqual(InstructionDecoder(bytes: [0xC7]).opcode, 0b1100011)
    }

    func testIsNOP() {
        XCTAssertTrue(InstructionDecoder(bytes: [0x90]).isNOP)
        XCTAssertFalse(InstructionDecoder(bytes: [0x91]).isNOP)
    }
}