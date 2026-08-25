import XCTest
@testable import Intel8086

final class MemoryTests: XCTestCase {

    func testMemoryStartsWithZero() {
        let memory = Memory()

        XCTAssertEqual(memory[0x00000], 0x00)
        XCTAssertEqual(memory[0xfffff], 0x00)
    }

    func testMemoryCanWriteByte() {
        var memory = Memory()

        memory[0x12345] = 0xab

        XCTAssertEqual(memory[0x12345], 0xab)
    }

    func testWriteWordUsesLittleEndian() {
        var memory = Memory()

        memory.writeWord(0x1234, at: 0x1000)

        XCTAssertEqual(memory[0x1000], 0x34)
        XCTAssertEqual(memory[0x1001], 0x12)
    }

    func testReadWordUsesLittleEndian() {
        var memory = Memory()

        memory[0x1000] = 0x34
        memory[0x1001] = 0x12

        XCTAssertEqual(memory.readWord(at: 0x1000), 0x1234)
    }

    func testWriteWordAtLastTwoBytes() {
        var memory = Memory()

        memory.writeWord(0x1234, at: 0xFFFFE)
        XCTAssertEqual(memory.readWord(at: 0xFFFFE), 0x1234)
        XCTAssertEqual(memory[0xFFFFE], 0x34)
        XCTAssertEqual(memory[0xFFFFF], 0x12)
    }

}