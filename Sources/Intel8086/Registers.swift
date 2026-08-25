struct Registers {
    var ax: Register16?
    // var bx: Register16
    // var cx: Register16
    // var dx: Register16

    // var sp: Register16
    // var bp: Register16
    // var si: Register16
    // var di: Register16

    var cs = Register16(value: 0xffff)
    // var ds: Register16
    // var es: Register16
    // var ss: Register16
    var ip = Register16(value: 0x0000)

    // var flags: Flag
}