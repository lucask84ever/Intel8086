struct Instruction {
    var bytes: [UInt8]

    var isNOP: Bool {
        bytes[0] == 0x90
    }

    var length: Int {
        var length = 1
        if hasModRM {
            length += 1
        }
        return length
    }

    var isMovRegisterMemoryToFromRegister: Bool {
        bytes[0] >> 2 == 0b100010
    }

    var isMovImmediateToRegister: Bool {
        bytes[0] >> 4 == 0b1011
    }

    var isMovImmediateToRegisterMemory: Bool {
        bytes[0] >> 1 == 0b1100011
    }

    var hasModRM: Bool {
        return isMovRegisterMemoryToFromRegister || isMovImmediateToRegisterMemory
    }

    var modRM: ModRM {
        ModRM(value: bytes[1])
    }
}