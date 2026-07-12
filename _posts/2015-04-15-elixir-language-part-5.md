---
layout: post
title: Elixir Language (Part 5)
date: 2015-04-15 16:26 +0530
categories: [Functional Programming]
tags: [elixir, functional-programming]
---

**Binaries**

In the last section, we talked about representing strings as UTF-8 encoded binary. But we left a topic for this section: How a character having code point above 255 is represented in binary?

Well, we all know that a single byte can only hold a value between 0 and 255. Let's consider the string hełło. Here ł has a code point 322.

This is where UTF-8 comes into picture. It solves the problem by using 2 bytes to represent each ł, and one byte each to represent h, e and o.

``` iex
iex> string = "hełło"
"hełło"
iex> byte_size string
7
iex> String.length string
5
```

Here, we can see that the byte size of the string is 7 while the string length is 5. The function byte_size/1 can be used to check how many bytes are actually used in the memory to represent the given string.

Read more: [Binaries, strings and char lists](http://elixir-lang.org/getting_started/6.html)

Originally posted on my blog: [Elixir Language (Part 5)](https://yedhukrishnan.blogspot.com/2015/04/elixir-language-part-5.html){:target="_blank" rel="noopener"}
