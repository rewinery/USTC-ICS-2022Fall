# Lab02 A Variant of the Fibonacci Sequence

[TOC]

## Task

Do you still remember the Fibonacci sequence of the midterm exam？

Now we expect you to calculate a variant of the Fibonacci sequence:
$$
F(0) = F(1) = 1 \\
F(N) = F(N - 2)\ \% \ p + F(N - 1)\ \%\ q\ (2\leq N \leq 1024) \\
p = 2^k\ (2\leq k\leq 10),\ 10 \leq q \leq 1024
$$
Note that **p** will be stored in **x3100**, **q** will be stored in **x3101** and **N** will be stored in **x3102**.

Your job: store **F(N)** in **x3103**.

R0-R7 are set to zeroes at the beginning, and your program should start at x3000.

Here are some examples:                                                                                                                                                                                                               

|  N   |  p   |  q   | F(N) |
| :--: | :--: | :--: | :--: |
| 100  | 256  | 123  | 146  |
| 200  | 512  | 456  | 818  |
| 300  | 1024 | 789  | 1219 |

## Score

Correctness for 50% and the report for other 50%.

### Submission

Note that from this experiment, each experiment requires using **assembly code**.

Here are some notifications:

- Your program should start with **.ORIG x3000**
- Your program should end with **.END**
- Your last instruction should be **TRAP x25 (HALT)**

- **Capitalized** keywords(also labels) are recommended (For example, use "ADD" instead of "add", use "NUMBER" instead of "number" )
- **Spaces** after **commas** (`ADD R0, R0, #1` rather than `ADD R0,R0,#1`)
- **Decimal** constants start with #, **hexadecimal** with lowercase x
- Write **comments** when necessary

> You may also refer to the textbook for more details of code style.

Your submission be structured as shown below.

```bash
PB21******_Name.zip
├── PB21******_Name_report.pdf
└── lab2.asm
```

### Reports

Your reports should contain at least the five parts below:

- purpose
- principles (e.g. how to deal with modulus)
- procedure  (e.g. bugs you encountered and how to solve them)
- results of your test
- answer to the question: How can you improve the efficiency of loop structure in your program? (Just describe your idea briefly.)

### Sth Interesting

Here are some questions worth thinking: 

> **You don't have to answer them in your report!** 
>
> **You can answer in your report, but that will bring you no more extra points but feedback from your TA.**
>
> **Don't worry!**

You may find that this fibonacci sequence has periodicity sometimes. For example, when (p,q) is (32, 16), (64, 32), or (32, 64).

1. Can you make a conclusion of the least positive period of these sequences.

2. Can your conclusion apply to all integer p that $4\leq p \leq 1024$? Prove that or give one counter example.

