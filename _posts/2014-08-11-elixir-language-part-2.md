---
layout: post
title: Elixir Language (Part 2)
date: 2014-08-11 22:32 +0530
categories: [Functional Programming]
tags: [elixir, functional-programming]
---

Here are the few things I liked about the language at the first glance:

**Lists and Tuples**

Square brackets are used in Elixir to specify a list of values. They can hold values of multiple data types.

``` iex
iex> [1, 2, true, :atom, 3]
[1, 2, true, :atom, 3]
```

They are represented in memory using linked lists. This means accessing the length of a list is a linear operation.

Tuples, unlike lists, store elements contigiuously in memory. They can also hold values of any type.

``` iex
iex> {:ok, "hello"}
{:ok, "hello"}
```

**Short-Circuit Operators: and, or**

By default, and and or operators are short-circuit operators in Elixir. That means, the right hand side of these operators will be executed only if the left hand side is not enough to determine the result.

``` iex
iex> false and error("This error will never be raised")
false

iex> true and error("This error will never be raised")
** (RuntimeError) undefined function: error/1
```

Here, the first expression returns false because 'false and anything' is always false. But in the second part, the left hand side is not enough to get the result. Hence, it tries to execute the right hand side, and it fails because there is no function called error/1.

In the next part, I'll share what I learned and liked about the match operator in Elixir.

*Read more:*

- *[(Linked) Lists](http://elixir-lang.org/getting_started/2.html#2.6-(linked)-lists)*
- *[Tuples](http://elixir-lang.org/getting_started/2.html#2.7-tuples)*
- *[Basic Operators](http://elixir-lang.org/getting_started/3.html)*
- *[Short-Circuit Evaluation](http://en.wikipedia.org/wiki/Short-circuit_evaluation) (wikipedia)*

Originally posted on my blog: [Elixir Language (Part 2)](https://yedhukrishnan.blogspot.com/2014/08/elixir-language-part-2.html){:target="_blank" rel="noopener"}
