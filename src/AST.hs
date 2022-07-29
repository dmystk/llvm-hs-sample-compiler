module AST where

data Expr
    = ENum Integer
    | EAdd Expr Expr
    | ESub Expr Expr
    | EMul Expr Expr
    | EDiv Expr Expr
    deriving (Show)
