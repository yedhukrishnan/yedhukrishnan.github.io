---
layout: post
title: Elixir Language (Part 3)
date: 2014-08-15 20:27 +0530
categories: [Functional Programming]
tags: [elixir, functional-programming]
---

**The Match Operator**

In Elixir, we use = operator to assign value to a variable:

``` iex
iex> x = 1
1
```

What's the big deal? Well, in Elixir, = is not just an assignment operator. It's a match operator.

``` iex
iex> x = 1
1
iex> 1 = x
1
```

As long as the left hand side and the right hand side are equal, Elixir will not complain. But when a mismatch occurs, it raises a MatchError:

``` iex
iex> 1 = x
1
iex> 2 = x
** (MatchError) no match of right hand side value: 1
```

For assigning value to a new variable, the variable should always be on the left hand side of the operator.

The match operator can be used to destructure complex data structures into its components. Here is an example where Elixir uses pattern matching on a list:

``` iex
iex> [a, b, c] = [1, 2, 3]
[1, 2, 3]
iex> a
1
```

Here is a common question that pops up in mind when we talk about the match operator. If we are using the expression x = 1 in Elixir. How does elixir know whether we want to do a match or assignment?

By default, Elixir always performs assignment if the variable is on the left hand side. If you specifically want to perform match, you can use the pin operator (^).

``` iex
iex> x = 1
1
iex> ^x = 2
** (MatchError) no match of right hand side value: 2
```

Here I explained the parts which I liked the most in Elixir. This is only meant for an introduction into the language. All the examples are taken from the Elixir's getting started guide.

Read more and learn here: [Elixir: Pattern Matching](http://elixir-lang.org/getting_started/4.html)

Originally posted on my blog: [Elixir Language (Part 3)](https://yedhukrishnan.blogspot.com/2014/08/elixir-language-part-3.html){:target="_blank" rel="noopener"}
