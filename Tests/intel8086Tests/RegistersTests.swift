import XCTest
@testable import Intel8086

final class RegistersTests: XCTestCase {

    func testRegisters() {
        let cpu = Intel8086()

        // XCTAssertEqual(cpu.registers.ax.value, 0x1234)
        XCTAssertEqual(cpu.registers.cs.value, 0xffff)
        XCTAssertEqual(cpu.registers.ip.value, 0x0000)
        XCTAssertNil(cpu.registers.ax)
    }

}