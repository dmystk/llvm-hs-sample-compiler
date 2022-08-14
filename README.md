# Sample Compiler using llvm-hs-pure and llvm-hs-pretty

This repository contains a sample implementation of a compiler using llvm-hs-pure and llvm-hs-pretty.

The compiler accepts a simple expression and outputs LLVM IR where prints the result of calculation.
For details about the expression, see the below BNF.

```text
<expr>   ::= <expr1>
<expr1>  ::= <expr2> "+" <expr2>
           | <expr2> "-" <expr2>
           | <expr2>
<expr2>  ::= <expr3> "*" <expr3>
           | <expr3> "/" <expr3>
           | <expr3>
<expr3>  ::= <number>
           | "(" <expr> ")"
```

## Building

```shell
$ brew install llvm@9
$ stack build
```

## Running

You can try a sample code by the following command:

```shell
$ stack run -- ./example/example.src
```

The abobe command outputs `./example/example.src.o`.
The below commands link the object file and execute the result.

```shell
$ ld -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem ./example/example.src.o
$ ./a.out
```
