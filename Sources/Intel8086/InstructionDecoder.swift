struct InstructionDecoder {
    var bytes: [UInt8]

    var instruction: UInt8 {
        bytes[0]
    }

    init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    init() {
        bytes = []
    }

    var modRM: ModRM {
        ModRM(value: bytes[1])
    }

    var opcode: UInt8 {
        if isMovRegisterMemoryToFromRegister {
            return (instruction & 0xFC) >> 2
        }
        if isMovImmediateToRegister {
            return instruction >> 4
        }
        return instruction >> 1
    }

    var direction: UInt8 {
        (instruction & 0x02) >> 1
    }

    var isMovRegisterMemoryToFromRegister: Bool {
        instruction >> 2 == 0b100010
    }

    var isMovImmediateToRegister: Bool {
        instruction >> 4 == 0b1011
    }

    var isMovImmediateToRegisterMemory: Bool {
        instruction >> 1 == 0b1100011
    }

    var hasModRM: Bool {
        return isMovRegisterMemoryToFromRegister || isMovImmediateToRegisterMemory
    }

    var width: UInt8 {
        if isMovImmediateToRegister {
            return (instruction >> 3) & 0x01
        }
        return instruction & 0x01
    }

    var length: Int {
        var length = 1
        if isMovImmediateToRegister {
            return length + immediateLength
        }
        if hasModRM {
            length += 1
            length += displacementLength
        }
        
        return length + immediateLength
    }

    var immediateLength: Int {
        if isMovRegisterMemoryToFromRegister {
            return 0
        }

        if isMovImmediateToRegister {
            return ((width & 0x01 ) == 0 ? 1 : 2)
        }

        if isMovImmediateToRegisterMemory {
            return ((width & 0x01) == 0 ? 1 : 2)
        }

        return 0
    }

    var displacementLength: Int {
        var modRMValue = modRM.mod == 2 ? 2 : modRM.mod == 1 ? 1 : 0
        modRMValue = modRM.mod == 0 && modRM.rm == 6 ? 2 : modRMValue
        return modRMValue
    }

    var isNOP: Bool {
        return bytes[0] == 0x90
    }

    func decode(bytes: [UInt8]) -> Instruction {
        return Instruction(bytes: bytes)
    }
}