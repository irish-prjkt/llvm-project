; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

; PR8862

define i32 @shift1(i32 %A, i32 %B) {
; CHECK-LABEL: @shift1(
; CHECK-NEXT:    ret i32 %A
;
  %C = lshr exact i32 %A, %B
  %D = shl nuw i32 %C, %B
  ret i32 %D
}

define i32 @shift2(i32 %A, i32 %B) {
; CHECK-LABEL: @shift2(
; CHECK-NEXT:    [[C:%.*]] = lshr i32 %A, %B
; CHECK-NEXT:    [[D:%.*]] = shl nuw i32 [[C]], %B
; CHECK-NEXT:    ret i32 [[D]]
;
  %C = lshr i32 %A, %B
  %D = shl nuw i32 %C, %B
  ret i32 %D
}

define i32 @shift3(i32 %A, i32 %B) {
; CHECK-LABEL: @shift3(
; CHECK-NEXT:    ret i32 %A
;
  %C = ashr exact i32 %A, %B
  %D = shl nuw i32 %C, %B
  ret i32 %D
}

define i32 @shift4(i32 %A, i32 %B) {
; CHECK-LABEL: @shift4(
; CHECK-NEXT:    ret i32 %A
;
  %C = shl nuw i32 %A, %B
  %D = lshr i32 %C, %B
  ret i32 %D
}

define i32 @shift5(i32 %A, i32 %B) {
; CHECK-LABEL: @shift5(
; CHECK-NEXT:    ret i32 %A
;
  %C = shl nsw i32 %A, %B
  %D = ashr i32 %C, %B
  ret i32 %D
}

define i32 @div1(i32 %V) {
; CHECK-LABEL: @div1(
; CHECK-NEXT:    ret i32 0
;
  %A = udiv i32 %V, -2147483648
  %B = udiv i32 %A, -2147483648
  ret i32 %B
}

define i32 @div2(i32 %V) {
; CHECK-LABEL: @div2(
; CHECK-NEXT:    ret i32 0
;
  %A = sdiv i32 %V, -1
  %B = sdiv i32 %A, -2147483648
  ret i32 %B
}

