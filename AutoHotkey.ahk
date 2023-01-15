; Swap :, ;
$vkBA::Send, :
+$vkBA::Send, `;

; Swap ", '
$vkDE::Send, "
+$vkDE::Send, '

; Single Ctrl to send ESC
!Esc::Send, {Esc}

^escape::
return

; Henkan
;; Embedded keyboard
$vkFF::Send,{vk1C}
; Muhenkan
;; Embedded keyboard
$vkEB::Send,{vk1D}

#ifWinNotActive ahk_class TscShellContainerClass
Ctrl::
     Send,{Esc}
     ; IME_SET(0)
     KeyWait,Ctrl
return

; Toggle window size with ^w
^+w::
    WinGet, tmp, MinMax, A
    If tmp = 1
        Send, #{Down}
    Else
        Send, #{Up}
return


; Press Alt+Q twice to close window 
!q::
 {
   count++
   settimer, actions, 200
 }
return

actions:
 {
  if (count = 1) {
      ; do nothing
    }
   else if (count = 2)
    {
      Send, !{F4}
    }
 count := 0
 }
return


; --------------------------------------------------
; Togge IME with LAlt / RAlt
; cf. https://github.com/karakaram/alt-ime-ahk
; --------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if    (WinActive(WinTitle))    {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;    DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
                 ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
    }

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}


; Razer Synapseなど、キーカスタマイズ系のツールを併用しているときのエラー対策
#MaxHotkeysPerInterval 350

; 主要なキーを HotKey に設定し、何もせずパススルーする
*~a::
*~b::
*~c::
*~d::
*~e::
*~f::
*~g::
*~h::
*~i::
*~j::
*~k::
*~l::
*~m::
*~n::
*~o::
*~p::
*~q::
*~r::
*~s::
*~t::
*~u::
*~v::
*~w::
*~x::
*~y::
*~z::
*~1::
*~2::
*~3::
*~4::
*~5::
*~6::
*~7::
*~8::
*~9::
*~0::
*~F1::
*~F2::
*~F3::
*~F4::
*~F5::
*~F6::
*~F7::
*~F8::
*~F9::
*~F10::
*~F11::
*~F12::
*~`::
*~~::
*~!::
*~@::
*~#::
*~$::
*~%::
*~^::
*~&::
*~*::
*~(::
*~)::
*~-::
*~_::
*~=::
*~+::
*~[::
*~{::
*~]::
*~}::
*~\::
*~|::
*~;::
*~'::
*~"::
*~,::
*~<::
*~.::
*~>::
*~/::
*~?::
*~Esc::
*~Tab::
*~Space::
*~Left::
*~Right::
*~Up::
*~Down::
*~Enter::
*~PrintScreen::
*~Delete::
*~Home::
*~End::
*~PgUp::
*~PgDn::
    Return

; 上部メニューがアクティブになるのを抑制
*~LAlt::Send {Blind}{vk07}
*~RAlt::Send {Blind}{vk07}

; 左 Alt 空打ちで IME を OFF
LAlt up::
    if (A_PriorHotkey == "*~LAlt")
    {
        IME_SET(0)
    }
    Return

; 右 Alt 空打ちで IME を ON
RAlt up::
    if (A_PriorHotkey == "*~RAlt")
    {
        IME_SET(1)
    }
    Return

