
struct InstructorDecode {
    var bytes: [UInt8]

    var instruction: UInt8 {
        bytes[0]
    }

    var modRM: ModRM {
        ModRM(value: bytes[1])
    }

    var opcode: UInt8 {
        (instruction & 0xFC) >> 2
    }

    var direction: UInt8 {
        (instruction & 0x02) >> 1
    }

    var width: UInt8 {
        (instruction & 0x01)
    }
}