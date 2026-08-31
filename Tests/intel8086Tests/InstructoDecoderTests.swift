import XCTest
@testable import Intel8086

final class InstructorDecoderTests: XCTestCase {

    func testDirectionZeroWidthZero() {
        let instructor = InstructorDecode(bytes: [0x00])
        XCTAssertEqual(instructor.opcode, 0b000000)
        XCTAssertEqual(instructor.direction, 0x00)
        XCTAssertEqual(instructor.width, 0x00)
    }

    func testDecodeOcode() {
        let instructor = InstructorDecode(bytes: [0x01])

        XCTAssertEqual(instructor.opcode, 0b000000)
        XCTAssertEqual(instructor.direction, 0x00)
        XCTAssertEqual(instructor.width, 0x01)
    }

    func testDecodeTwo() {
        let instructor = InstructorDecode(bytes: [0x02])

        XCTAssertEqual(instructor.opcode, 0b000000)
        XCTAssertEqual(instructor.direction, 0x01)
        XCTAssertEqual(instructor.width, 0x00)
    }
    func testDecodeInstruction() {
        let instructor = InstructorDecode(bytes: [0x03])

        XCTAssertEqual(instructor.opcode, 0b000000)
        XCTAssertEqual(instructor.direction, 0x01)
        XCTAssertEqual(instructor.width, 0x01)
    }

    func testDecodeOcode1() {
        let instructor = InstructorDecode(bytes: [0x01, 0xD8])

        XCTAssertEqual(instructor.opcode, 0b000000)
        XCTAssertEqual(instructor.direction, 0x00)
        XCTAssertEqual(instructor.width, 0x01)

        XCTAssertEqual(instructor.modRM.mod, 0b11)
        XCTAssertEqual(instructor.modRM.reg, 0b011)
        XCTAssertEqual(instructor.modRM.rm, 0b000)
    }

    func testDecodeInstruction1() {
        let instructor = InstructorDecode(bytes: [0x03, 0xFF])

        XCTAssertEqual(instructor.opcode, 0b000000)
        XCTAssertEqual(instructor.direction, 0x01)
        XCTAssertEqual(instructor.width, 0x01)

        XCTAssertEqual(instructor.modRM.mod, 0b11)
        XCTAssertEqual(instructor.modRM.reg, 0b111)
        XCTAssertEqual(instructor.modRM.rm, 0b111)
    }

    func testDirectionZeroWidthZero1() {
        let instructor = InstructorDecode(bytes: [0x09, 0x00])
        XCTAssertEqual(instructor.opcode, 0b000010)
        XCTAssertEqual(instructor.direction, 0x00)
        XCTAssertEqual(instructor.width, 0x01)

        XCTAssertEqual(instructor.modRM.mod, 0b00)
        XCTAssertEqual(instructor.modRM.reg, 0b000)
        XCTAssertEqual(instructor.modRM.rm, 0b000)

    }
        func testDiretion() {
        let instructor = InstructorDecode(bytes: [0x0A, 0x80])

        XCTAssertEqual(instructor.opcode, 0b000010)
        XCTAssertEqual(instructor.direction, 0x01)
        XCTAssertEqual(instructor.width, 0x00)

        XCTAssertEqual(instructor.modRM.mod, 0b10)
        XCTAssertEqual(instructor.modRM.reg, 0b000)
        XCTAssertEqual(instructor.modRM.rm, 0b000)
    }
}