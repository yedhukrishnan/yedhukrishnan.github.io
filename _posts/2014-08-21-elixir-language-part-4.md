---
layout: post
title: Elixir Language (Part 4)
date: 2014-08-21 21:58 +0530
categories: [Functional Programming]
tags: [elixir, functional-programming]
---

**Binaries**

In Elixir, strings are UTF-8 encoded binaries.

What is a binary?

A binary is just a sequence of bytes. By default, each character in a string is internally represented in memory using 8 bits.

Let's take a simple example. The string "hello" in UTF-8 encoded binary form is 104, 101, 108, 108, 111. As you can see, each character uses a number (code point) between 0 and 255, which is represented with 8 bits or 1 byte.

You can define a binary using <<>> as shown below.

``` iex
iex> <<0, 1, 2, 3>>
<<0, 1, 2, 3>>
```

We have the string concatenation operator <> in Elixir, which is actually a binary concatenation operator.

``` iex
iex> "hello" <> "world"
"helloworld"
iex> <<0, 1, 2, 3>> <> <<4>>
<<0, 1, 2, 3, 4>>
```

Let's see "hello" in Elixir's binary form:

``` iex
iex> "hello" <> <<0>>
<<104, 101, 108, 108, 111, 0>>
```

Here, I just used a concatenation operator to append a binary to a string. It converted the string to its internal binary representation.

The unicode standard assigns code points to many of the characters we know. For example, a has code point of 97. Here, as you can see, h has a code point of 104.

All commonly occuring characters have code points between 0 and 255. But there are characters whose code points are above 255, which cannot be represented in memory using a single byte. In the next post, I'll explain how they are represented and stored in memory.

Read more: [Binaries, strings and char lists](http://elixir-lang.org/getting_started/6.html)

Originally posted on my blog: [Elixir Language (Part 4)](https://yedhukrishnan.blogspot.com/2014/08/elixir-language-part-4.html){:target="_blank" rel="noopener"}
