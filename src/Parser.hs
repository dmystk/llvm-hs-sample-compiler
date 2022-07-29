{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use <$>" #-}
module Parser
    ( Parser.parse
    ) where

import AST
import Prelude hiding (div)
import Data.Functor.Identity
import Text.Parsec as P
import qualified Text.Parsec.Token as P
import Text.Parsec.Language (emptyDef)

type Parser a = ParsecT String () Identity a

p = P.makeTokenParser emptyDef
integer = P.integer p
symbol = P.symbol p
parens = P.parens p

parse :: String -> Either ParseError Expr
parse = P.parse parser ""

parser :: Parser Expr
parser = const <$> expr <*> eof

expr :: Parser Expr
expr = expr1

expr1 :: Parser Expr
expr1 = add
    <|> sub
    <|> expr2

add :: Parser Expr
add = try $ do
    e1 <- expr2
    op <- symbol "+"
    e2 <- expr2
    return $ EAdd e1 e2

sub :: Parser Expr
sub = try $ do
    e1 <- expr2
    op <- symbol "-"
    e2 <- expr2
    return $ ESub e1 e2

expr2 :: Parser Expr
expr2 = mul
    <|> div
    <|> expr3

mul :: Parser Expr
mul = try $ do
    e1 <- expr3
    op <- symbol "*"
    e2 <- expr3
    return $ EMul e1 e2

div :: Parser Expr
div = try $ do
    e1 <- expr3
    op <- symbol "/"
    e2 <- expr3
    return $ EDiv e1 e2

expr3 :: Parser Expr
expr3 = number
    <|> parens expr1

number :: Parser Expr
number = ENum <$> integer
