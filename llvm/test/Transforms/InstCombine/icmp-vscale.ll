; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

define i1 @ugt_vscale64_x_32() vscale_range(1,16) {
; CHECK-LABEL: @ugt_vscale64_x_32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 false
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %num_els = shl i64 %vscale, 5
  %res = icmp ugt i64 %num_els, 1024
  ret i1 %res
}

define i1 @ugt_vscale64_x_31() vscale_range(1,16) {
; CHECK-LABEL: @ugt_vscale64_x_31(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 false
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %num_els = mul i64 %vscale, 31
  %res = icmp ugt i64 %num_els, 1024
  ret i1 %res
}

define i1 @ugt_vscale16_x_32() vscale_range(1,16) {
; CHECK-LABEL: @ugt_vscale16_x_32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 false
;
entry:
  %vscale = call i16 @llvm.vscale.i16()
  %num_els = shl i16 %vscale, 5
  %res = icmp ugt i16 %num_els, 1024
  ret i1 %res
}

define i1 @ult_vscale16() vscale_range(1,16) {
; CHECK-LABEL: @ult_vscale16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 false
;
entry:
  %vscale = call i16 @llvm.vscale.i16()
  %res = icmp ult i16 1024, %vscale
  ret i1 %res
}

define i1 @ule_vscale64() vscale_range(1,16) {
; CHECK-LABEL: @ule_vscale64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 false
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %res = icmp ule i64 1024, %vscale
  ret i1 %res
}

define i1 @ueq_vscale64_range4_4() vscale_range(4,4) {
; CHECK-LABEL: @ueq_vscale64_range4_4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 true
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %res = icmp eq i64 %vscale, 4
  ret i1 %res
}

define i1 @ne_vscale64_x_32() vscale_range(1,16) {
; CHECK-LABEL: @ne_vscale64_x_32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i1 true
;
entry:
  %vscale = call i64 @llvm.vscale.i64()
  %num_els = mul i64 %vscale, 32
  %res = icmp ne i64 %num_els, 39488
  ret i1 %res
}

declare i8 @llvm.vscale.i8()
declare i16 @llvm.vscale.i16()
declare i32 @llvm.vscale.i32()
declare i64 @llvm.vscale.i64()
