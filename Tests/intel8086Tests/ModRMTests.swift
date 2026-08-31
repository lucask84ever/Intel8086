import XCTest
@testable import Intel8086

final class ModRMTests: XCTestCase {

    func testModRM() {
        let modRM = ModRM(value: 0x00)

        XCTAssertEqual(modRM.mod, 0b00)
        XCTAssertEqual(modRM.reg, 0b000)
        XCTAssertEqual(modRM.rm, 0b000)
    }

    func testModRMWithMemoryDisplacement() {
        let modRM = ModRM(value: 0x80)
        XCTAssertEqual(modRM.mod, 0b10)
        XCTAssertEqual(modRM.reg, 0b000)
        XCTAssertEqual(modRM.rm, 0b000)
    }

    func testModRMWithRegisterMode() {
        let modRM = ModRM(value: 0xD8)

        XCTAssertEqual(modRM.mod, 0b11)
        XCTAssertEqual(modRM.reg, 0b011)
        XCTAssertEqual(modRM.rm, 0b000)
    }

    func testModRMWithMaximumValues() {
        let modRM = ModRM(value: 0xFF)

        XCTAssertEqual(modRM.mod, 0b11)
        XCTAssertEqual(modRM.reg, 0b111)
        XCTAssertEqual(modRM.rm, 0b111)
    }
}