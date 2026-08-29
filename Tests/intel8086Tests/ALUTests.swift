import XCTest
@testable import Intel8086

final class ALUTests: XCTestCase {
    func testAddTwoBytes() {
        let alu = ALU(()

        let result = alu.add(3, 5)

        XCTAssertEqual(result, 8)
    }
}