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

        memory[0x12345] = 0xAB

        XCTAssertEqual(memory[0x12345], 0xAB)
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

    func testMemoryAddressWrapsAround() {
        var memory = Memory()

        memory[0xFFFFF] = 0x34
        memory[0x00000] = 0x12
        XCTAssertEqual(memory.readWord(at: 0xFFFFF), 0x1234)
    }

    func testMemoryAddressWrapsAroundMultipleTimes() {
        var memory = Memory()
        memory.writeWord(0xAB, at: 0x00000)

        XCTAssertEqual(memory.readWord(at: 0x100000), 0xAB)
        XCTAssertEqual(memory.readWord(at: 0x200000), 0xAB)
    }

    func testLimits() {
        var memory = Memory()
        memory.writeWord(0x0000, at: 0x00000)
    }
}