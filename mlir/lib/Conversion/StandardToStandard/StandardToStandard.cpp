//===- StandardToStandard.cpp - Std intra-dialect lowering ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/StandardToStandard/StandardToStandard.h"
#include "mlir/Dialect/StandardOps/IR/Ops.h"
#include "mlir/Transforms/DialectConversion.h"

using namespace mlir;

namespace {
// Converts the operand and result types of the Standard's CallOp, used together
// with the FuncOpSignatureConversion.
struct CallOpSignatureConversion : public OpConversionPattern<CallOp> {
  CallOpSignatureConversion(MLIRContext *ctx, TypeConverter &converter)
      : OpConversionPattern(ctx), converter(converter) {}

  /// Hook for derived classes to implement combined matching and rewriting.
  PatternMatchResult
  matchAndRewrite(CallOp callOp, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const override {
    FunctionType type = callOp.getCalleeType();

    // Convert the original function results.
    SmallVector<Type, 1> convertedResults;
    if (failed(converter.convertTypes(type.getResults(), convertedResults)))
      return matchFailure();

    // Substitute with the new result types from the corresponding FuncType
    // conversion.
    rewriter.replaceOpWithNewOp<CallOp>(callOp, callOp.callee(),
                                        convertedResults, operands);
    return matchSuccess();
  }

  /// The type converter to use when rewriting the signature.
  TypeConverter &converter;
};
} // end anonymous namespace

void mlir::populateCallOpTypeConversionPattern(
    OwningRewritePatternList &patterns, MLIRContext *ctx,
    TypeConverter &converter) {
  patterns.insert<CallOpSignatureConversion>(ctx, converter);
}
