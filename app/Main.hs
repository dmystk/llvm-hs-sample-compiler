module Main where

import System.IO
import System.Environment
import LLVM.Analysis
import LLVM.Context
import LLVM.Module
import LLVM.Target

import Parser
import Compiler

main :: IO ()
main = do
  args <- getArgs
  let srcPath = head args
  src <- readFile srcPath

  let distPath = srcPath ++ ".o"
  let result = compile <$> parse src
  case result of
    Right mod -> withContext $ \ctx ->
      withModuleFromAST ctx mod $ \mod' -> do
        verify mod'
        withHostTargetMachineDefault $ \target ->
          writeObjectToFile target (File distPath) mod'
    Left err -> print err
