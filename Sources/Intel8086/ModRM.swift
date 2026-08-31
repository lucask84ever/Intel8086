struct ModRM {
    let value: UInt8

    var mod: UInt8 {
        get {
            UInt8(value >> 6)
        }
    }

    var reg: UInt8 {
        get {
            (value >> 3) &  0x07
        }
    }

    var rm: UInt8 {
        get {
            value & 0x07
        }
    }
}