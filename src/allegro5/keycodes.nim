type
  AllegroKey* {.pure.} = enum
    keyA = 1
    keyB = 2
    keyC = 3
    keyD = 4
    keyE = 5
    keyF = 6
    keyG = 7
    keyH = 8
    keyI = 9
    keyJ = 10
    keyK = 11
    keyL = 12
    keyM = 13
    keyN = 14
    keyO = 15
    keyP = 16
    keyQ = 17
    keyR = 18
    keyS = 19
    keyT = 20
    keyU = 21
    keyV = 22
    keyW = 23
    keyX = 24
    keyY = 25
    keyZ = 26

    key0 = 27
    key1 = 28
    key2 = 29
    key3 = 30
    key4 = 31
    key5 = 32
    key6 = 33
    key7 = 34
    key8 = 35
    key9 = 36

    keyPad0 = 37
    keyPad1 = 38
    keyPad2 = 39
    keyPad3 = 40
    keyPad4 = 41
    keyPad5 = 42
    keyPad6 = 43
    keyPad7 = 44
    keyPad8 = 45
    keyPad9 = 46

    keyF1  = 47
    keyF2  = 48
    keyF3  = 49
    keyF4  = 50
    keyF5  = 51
    keyF6  = 52
    keyF7  = 53
    keyF8  = 54
    keyF9  = 55
    keyF10 = 56
    keyF11 = 57
    keyF12 = 58

    keyEscape     = 59
    keyTilde      = 60
    keyMinus      = 61
    keyEquals     = 62
    keyBackspace  = 63
    keyTab        = 64
    keyOpenbrace  = 65
    keyClosebrace = 66
    keyEnter      = 67
    keySemicolon  = 68
    keyQuote      = 69
    keyBackslash  = 70
    keyBackslash2 = 71 # DirectInput calls this DIK_OEM_102: "< > | on UK/Germany keyboards"
    keyComma      = 72
    keyFullstop   = 73
    keySlash      = 74
    keySpace      = 75

    keyInsert     = 76
    keyDelete     = 77
    keyHome       = 78
    keyEnd        = 79
    keyPageUp     = 80
    keyPageDown   = 81
    keyArrowLeft  = 82
    keyArrowRight = 83
    keyArrowUp    = 84
    keyArrowDown  = 85

    keyPadSlash     = 86
    keyPadAsterisk  = 87
    keyPadMinus     = 88
    keyPadPlus      = 89
    keyPadDelete    = 90
    keyPadEnter     = 91

    keyPrintscreen  = 92
    keyPause        = 93

    keyAbntC1     = 94
    keyYen        = 95
    keyKana       = 96
    keyConvert    = 97
    keyNoConvert  = 98
    keyAT         = 99
    keyCircumflex = 100
    keyColon2     = 101
    keyKanji      = 102

    keyPadEquals  = 103 # macOS
    keyBackquote  = 104 # macOS
    keySemicolon2 = 105 # macOS -- TODO: ask lillo what this should be
    keyCommand    = 106 # macOS
   
    keyBack       = 107 # Android back key
    keyVolumeUp   = 108
    keyVolumeDown = 109

    # Android game keys
    keySearch     = 110
    keyDPadCenter = 111
    keyButtonX    = 112
    keyButtonY    = 113
    keyDPadUp     = 114
    keyDPadDown   = 115
    keyDPadLeft   = 116
    keyDPadRight  = 117
    keySelect     = 118
    keyStart      = 119
    keyButtonL1   = 120
    keyButtonR1   = 121
    keyButtonL2   = 122
    keyButtonR2   = 123
    keyButtonA    = 124
    keyButtonB    = 125
    keyThumbl     = 126
    keyThumbr     = 127
    keyUnknown    = 128

   #[ All codes up to before keyMODIFIERS can be freely
      assignedas additional unknown keys like various multimedia
      and application keys keyboards may have.
    ]#
    # keyModifiers = 215
    keyLeftShift  = 215
    keyRightShift = 216
    keyLeftCtrl   = 217
    keyRightCtrl  = 218
    keyAlt        = 219
    keyAltGr      = 220
    keyLeftWin    = 221
    keyRightWin   = 222
    keyMenu       = 223
    keyScrollLock = 224
    keyNumLock    = 225
    keyCapsLock   = 226
    keyMax        = 227
  AllegroKeyMod* {.pure.} = enum
    keyShift      = 0x00001
    keyCtrl       = 0x00002
    keyAlt        = 0x00004
    keyLeftWin    = 0x00008
    keyRightWin   = 0x00010
    keyMenu       = 0x00020
    keyAltGr      = 0x00040
    keyCommand    = 0x00080
    keyScrollLock = 0x00100
    keyNumLock    = 0x00200
    keyCapsLock   = 0x00400
    keyInaltseq   = 0x00800
    keyAccent1    = 0x01000
    keyAccent2    = 0x02000
    keyAccent3    = 0x04000
    keyAccent4    = 0x08000
