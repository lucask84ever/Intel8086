import XCTest
@testable import Intel8086

final class InstructionTests: XCTestCase {
    func testDecodeNOP() {
        let decoder = InstructionDecoder()

        let instruction = decoder.decode(bytes: [0x90])
        XCTAssertTrue(instruction.isNOP)
    }

    func testDecodeNonNOP() {
        let decoder = InstructionDecoder()

        let instruction = decoder.decode(bytes: [0x91])
        XCTAssertFalse(instruction.isNOP)
    }

    func testDecodeNOPLength() {
        let decoder = InstructionDecoder()
        let instruction = decoder.decode(bytes: [0x90])
        XCTAssertEqual(instruction.length, 1)
    }

    func testDecodeInstructionLengthThatHaveModRM() {
        let decoder = InstructionDecoder()
        let instruction = decoder.decode(bytes: [0x89, 0xD8])
        XCTAssertEqual(instruction.length, 2)
    }
}