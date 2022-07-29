module Main where

import System.IO
import System.Environment
import qualified Data.Text.Lazy.IO as LT

import Parser
import Compiler

main :: IO ()
main = do
  args <- getArgs
  let srcPath = head args
  src <- readFile srcPath

  let distPath = srcPath ++ ".ll"
  let result = compile <$> parse src
  case result of
    Right ir -> LT.writeFile distPath ir
    Left err -> print err
