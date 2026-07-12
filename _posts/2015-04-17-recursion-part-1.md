---
layout: post
title: Recursion (Part 1)
date: 2015-04-17 21:16 +0530
categories: [Functional Programming]
tags: [elixir, functional-programming, recursion]
---

Unlike in imperative languages, functional programming languages (including Elixir) achieve looping through recursion. Why? To explain that, let's consider C:

``` c
for(i = 0; i < 5; i++) {
  sum = sum + i;
}
```

Here we are modifying (mutating) the value of i as well as sum in each interation. Mutation is considered as a bad practice and functional programming languages do not encourage it. Let's see some basic examples of recursion in Elixir.

Say, we want to print the message "hello" five times. How do we do that?

``` elixir
defmodule Recursion do
  def print_hello(n) when n <= 1 do
    IO.puts "hello"
  end

  def print_hello(n) do
    IO.puts "hello"
    print_hello(n - 1)
  end
end

Recursion.print_hello("Hello!", 3)
# Hello!
# Hello!
# Hello!
```

Here, defmodule is used to define a module (group of several functions). We can have multiple definitions of the same function. In the first function when n <= 1 is a guard. This function will get executed only when the guard condition is satisfied (no wonder why it is called a guard!). When there are multiple clauses (definitions) of the same function, Elixir looks for a match and executes it when it finds one. If no matches are found, it will throw error.

In this case, when n = 3 and n = 2, the second clause will be executed. When n = 1, the first clause will get executed.

Read more:

- [Modules](http://elixir-lang.org/getting-started/modules.html)
- [Recursion](http://elixir-lang.org/getting-started/recursion.html)

Originally posted on my blog: [Recursion (Part 1)](https://yedhukrishnan.blogspot.com/2015/04/recursion-part-1.html){:target="_blank" rel="noopener"}
