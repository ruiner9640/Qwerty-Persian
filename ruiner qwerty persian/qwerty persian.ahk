#Requires AutoHotkey v2.0
SendMode "Input"
SetWorkingDir A_ScriptDir
ProcessSetPriority "High"

global g_t9Timeout := 400
global g_enabled := true
global g_isPersian := false

global g_lastKey := ""
global g_pressCount := 0

^+F12:: {
    global g_enabled
    g_enabled := !g_enabled
    ToolTip "Persian T9: " (g_enabled ? "ON" : "OFF")
    SetTimer () => ToolTip(), -1000
}

global g_lower := Map(
    "q", ["ق"],
    "w", ["ا"],
    "e", ["ِ"],
    "r", ["ر"],
    "t", ["ت"],
    "y", ["ی"],
    "u", ["و"],
    "i", ["ی"],
    "o", ["ُ"],
    "p", ["پ"],
    "a", ["َ"],
    "s", ["س", "ص", "ث"],
    "d", ["د"],
    "f", ["ف"],
    "g", ["گ"],
    "h", ["ه"],
    "j", ["ج"],
    "k", ["ک"],
    "l", ["ل"],
    "z", ["ز", "ذ"],
    "x", ["خ"],
    "c", ["چ"],
    "v", ["و"],
    "b", ["ب"],
    "n", ["ن"],
    "m", ["م"]
)

global g_upper := Map(
    "q", ["غ"],
    "w", ["ع" ,"أ"],
    "e", ["ه"],
    "r", ["@"],
    "t", ["ط"],
    "y", ["ئ"],
    "u", ["ـ"],
    "i", ["ٰ"],
    "o", ["و"],
    "p", ["ْ"],
    "a", ["آ"],
    "s", ["ش"],
    "d", ["ّ"],
    "f", ["#"],
    "g", ["*"],
    "h", ["ح"],
    "j", ["ژ"],
    "k", ["("],
    "l", [")"],
    "z", ["ض", "ظ"],
    "x", ["«"],
    "c", ["»"],
    "v", ["ؤ"],
    "b", ["‌"],
    "n", ["ً"],
    "m", ["!"]
)

backtick := Chr(96)

g_lower[backtick] := [backtick, "×"]
g_lower["1"] := ["۱"]
g_lower["2"] := ["۲"]
g_lower["3"] := ["۳"]
g_lower["4"] := ["۴"]
g_lower["5"] := ["۵"]
g_lower["6"] := ["۶"]
g_lower["7"] := ["۷"]
g_lower["8"] := ["۸"]
g_lower["9"] := ["۹"]
g_lower["0"] := ["۰"]
g_lower["-"] := ["-"]
g_lower["="] := ["="]
g_lower["["] := ["["]
g_lower["]"] := ["]"]
g_lower["\"] := ["\"]
g_lower[";"] := [";"]
g_lower["'"] := ["'"]
g_lower[","] := ["," ,"،" ,"؛"]
g_lower["."] := ["."]
g_lower["/"] := ["/"]

g_upper[backtick] := ["~", "÷"]
g_upper["1"] := ["1" ,"!"]
g_upper["2"] := ["2" ,"@"]
g_upper["3"] := ["3" ,"#"]
g_upper["4"] := ["4" ,"$"]
g_upper["5"] := ["5" ,"٪"]
g_upper["6"] := ["6" ,"^"]
g_upper["7"] := ["7" ,"&"]
g_upper["8"] := ["8" ,"*"]
g_upper["9"] := ["9" ,"("]
g_upper["0"] := ["0" ,")"]
g_upper["-"] := ["_"]
g_upper["="] := ["+"]
g_upper["["] := ["{"]
g_upper["]"] := ["}"]
g_upper["\"] := ["|"]
g_upper[";"] := [":"]
g_upper["'"] := [Chr(34)]
g_upper[","] := ["<", "«"]
g_upper["."] := [">", "»"]
g_upper["/"] := ["؟"]

CommitT9() {
    global g_lastKey, g_pressCount
    g_lastKey := ""
    g_pressCount := 0
}

HandleKey(keyName, isShift) {
    global g_lastKey, g_pressCount, g_t9Timeout
    global g_lower, g_upper

    Critical "On"
    selectedMap := isShift ? g_upper : g_lower

    if !selectedMap.Has(keyName) {
        SendInput("{Text}" . keyName)
        CommitT9()
        Critical "Off"
        return
    }

    chars := selectedMap[keyName]
    if chars.Length = 0 || (chars.Length = 1 && chars[1] = "") {
        CommitT9()
        Critical "Off"
        return
    }

    if chars.Length = 1 {
        SendInput("{Text}" . chars[1])
        CommitT9()
        Critical "Off"
        return
    }

    SetTimer(CommitT9, -g_t9Timeout)
    if (g_lastKey == keyName) {
        g_pressCount++
        SendInput("{Backspace}")
    } else {
        CommitT9()
        g_pressCount := 1
    }
    g_lastKey := keyName
    local idx := Mod(g_pressCount - 1, chars.Length)
    SendInput("{Text}" . chars[idx + 1])
    Critical "Off"
}

CheckPersianLayout() {
    global g_isPersian
    hwnd := WinActive("A")
    if !hwnd {
        g_isPersian := false
        return
    }
    threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt", 0)
    if !threadId {
        g_isPersian := false
        return
    }
    curLayout := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
    g_isPersian := (curLayout & 0xFFFF) = 0x0429
}

IsActive() {
    global g_enabled, g_isPersian
    return g_enabled && g_isPersian
}

SetTimer CheckPersianLayout, 300

#HotIf IsActive()

$SC010:: HandleKey("q", false)
$SC011:: HandleKey("w", false)
$SC012:: HandleKey("e", false)
$SC013:: HandleKey("r", false)
$SC014:: HandleKey("t", false)
$SC015:: HandleKey("y", false)
$SC016:: HandleKey("u", false)
$SC017:: HandleKey("i", false)
$SC018:: HandleKey("o", false)
$SC019:: HandleKey("p", false)
$SC01E:: HandleKey("a", false)
$SC01F:: HandleKey("s", false)
$SC020:: HandleKey("d", false)
$SC021:: HandleKey("f", false)
$SC022:: HandleKey("g", false)
$SC023:: HandleKey("h", false)
$SC024:: HandleKey("j", false)
$SC025:: HandleKey("k", false)
$SC026:: HandleKey("l", false)
$SC02C:: HandleKey("z", false)
$SC02D:: HandleKey("x", false)
$SC02E:: HandleKey("c", false)
$SC02F:: HandleKey("v", false)
$SC030:: HandleKey("b", false)
$SC031:: HandleKey("n", false)
$SC032:: HandleKey("m", false)

$SC029:: HandleKey(Chr(96), false)
$SC002:: HandleKey("1", false)
$SC003:: HandleKey("2", false)
$SC004:: HandleKey("3", false)
$SC005:: HandleKey("4", false)
$SC006:: HandleKey("5", false)
$SC007:: HandleKey("6", false)
$SC008:: HandleKey("7", false)
$SC009:: HandleKey("8", false)
$SC00A:: HandleKey("9", false)
$SC00B:: HandleKey("0", false)
$SC00C:: HandleKey("-", false)
$SC00D:: HandleKey("=", false)
$SC01A:: HandleKey("[", false)
$SC01B:: HandleKey("]", false)
$SC02B:: HandleKey("\", false)
$SC027:: HandleKey(";", false)
$SC028:: HandleKey("'", false)
$SC033:: HandleKey(",", false)
$SC034:: HandleKey(".", false)
$SC035:: HandleKey("/", false)

+$SC010:: HandleKey("q", true)
+$SC011:: HandleKey("w", true)
+$SC012:: HandleKey("e", true)
+$SC013:: HandleKey("r", true)
+$SC014:: HandleKey("t", true)
+$SC015:: HandleKey("y", true)
+$SC016:: HandleKey("u", true)
+$SC017:: HandleKey("i", true)
+$SC018:: HandleKey("o", true)
+$SC019:: HandleKey("p", true)
+$SC01E:: HandleKey("a", true)
+$SC01F:: HandleKey("s", true)
+$SC020:: HandleKey("d", true)
+$SC021:: HandleKey("f", true)
+$SC022:: HandleKey("g", true)
+$SC023:: HandleKey("h", true)
+$SC024:: HandleKey("j", true)
+$SC025:: HandleKey("k", true)
+$SC026:: HandleKey("l", true)
+$SC02C:: HandleKey("z", true)
+$SC02D:: HandleKey("x", true)
+$SC02E:: HandleKey("c", true)
+$SC02F:: HandleKey("v", true)
+$SC030:: HandleKey("b", true)
+$SC031:: HandleKey("n", true)
+$SC032:: HandleKey("m", true)

+$SC029:: HandleKey(Chr(96), true)
+$SC002:: HandleKey("1", true)
+$SC003:: HandleKey("2", true)
+$SC004:: HandleKey("3", true)
+$SC005:: HandleKey("4", true)
+$SC006:: HandleKey("5", true)
+$SC007:: HandleKey("6", true)
+$SC008:: HandleKey("7", true)
+$SC009:: HandleKey("8", true)
+$SC00A:: HandleKey("9", true)
+$SC00B:: HandleKey("0", true)
+$SC00C:: HandleKey("-", true)
+$SC00D:: HandleKey("=", true)
+$SC01A:: HandleKey("[", true)
+$SC01B:: HandleKey("]", true)
+$SC02B:: HandleKey("\", true)
+$SC027:: HandleKey(";", true)
+$SC028:: HandleKey("'", true)
+$SC033:: HandleKey(",", true)
+$SC034:: HandleKey(".", true)
+$SC035:: HandleKey("/", true)

#HotIf
