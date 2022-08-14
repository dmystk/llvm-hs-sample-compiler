{-# LANGUAGE OverloadedStrings #-}
module Compiler
    ( compile
    ) where

import AST

import Data.Functor.Identity

import LLVM.AST hiding (function)
import LLVM.AST.Type
import LLVM.IRBuilder


type LLVMBuilder = IRBuilderT (ModuleBuilderT Identity)

compile :: Expr -> Module
compile expr = buildModule "main" $ do
    printf <- externVarArgs "printf" [ptr i8] i32
    format <- globalStringPtr "%d\n" "format"
    function "main" [] i32 $ \[] -> do
        entry <- block `named` "entry"; do
            result <- toOperand expr
            call printf [(ConstantOperand format, []), (result, [])]
            ret (int32 0)

toOperand :: Expr -> LLVMBuilder Operand
toOperand (ENum n) = return (int32 n)
toOperand (EAdd e1 e2) = binOp e1 e2 add
toOperand (ESub e1 e2) = binOp e1 e2 sub
toOperand (EMul e1 e2) = binOp e1 e2 mul
toOperand (EDiv e1 e2) = binOp e1 e2 sdiv

binOp :: Expr
      -> Expr
      -> (Operand -> Operand -> LLVMBuilder Operand)
      -> LLVMBuilder Operand
binOp e1 e2 f = do
    o1 <- toOperand e1
    o2 <- toOperand e2
    f o1 o2
