struct Flags {
    var value: UInt16

    var carry: Bool {
        set {
            if newValue {
                value |= 0x0001
            } else {
                value &= ~0x0001
            }
        }

        get {
            (value & 0x0001) != 0
        }
    }

    var parity: Bool {
        set {
            if newValue {
                value |= 0x0004
            } else {
                value &= ~0x0004
            }
        }

        get {
            (value & 0x0004) != 0
        }
    }


    var auxiliaryCarry: Bool {
        set {
            if newValue {
                value |= 0x0010
            } else {
                value &= ~0x0010
            }
        }

        get {
            (value & 0x0010) != 0
        }
    }

    var zero: Bool {
        set {
            if newValue {
                value |= 0x0040
            } else {
                value &= ~0x0040
            }
        }

        get {
            (value & 0x0040) != 0
        }
    }

    var sign: Bool {
        set {
            if newValue {
                value |= 0x0080
            } else {
                value &= ~0x0080
            }
        }

        get {
            (value & 0x0080) != 0
        }
    }

    var trap: Bool {
        set {
            if newValue {
                value |= 0x0100
            } else {
                value &= ~0x0100
            }
        }
        get {
            (value & 0x0100) != 0
        }
    }

    var interrupt: Bool {
        set {
            if newValue {
                value |= 0x0200
            } else {
                value &= ~0x200
            }
        }
        get {
            (value & 0x200) != 0
        }
    }

    var direction: Bool {
        set {
            if newValue {
                value |= 0x0400
            } else {
                value &= ~0x0400
            }
        }

        get {
            (value & 0x400) != 0
        }
    }

    var overflow: Bool {
                set {
            if newValue {
                value |= 0x0800
            } else {
                value &= ~0x0800
            }
        }

        get {
            (value & 0x800) != 0
        }
    }
}

