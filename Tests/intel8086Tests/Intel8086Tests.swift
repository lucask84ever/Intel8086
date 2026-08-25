
import XCTest
@testable import Intel8086

final class Intel8086Tests: XCTestCase {

    func testPhysicalAddressUsesCSAndIP() {
        let cpu = Intel8086(
            registers: Registers(
                cs: Register16(value: 0x1000),
                ip: Register16(value: 0x0020)
            )
        )

        XCTAssertEqual(cpu.physicalAddress, 0x10020)
    }

}