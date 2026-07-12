---
layout: post
title: Elixir Language (Part 1)
date: 2014-08-10 17:06 +0530
categories: [Functional Programming]
tags: [elixir, functional-programming]
---

After listening to the *Introduction into Elixir language*, by Dave Thomas, in [Bangalore Ruby Users Group meetup](http://www.meetup.com/Bangalore-Ruby-Users-Group/events/151655272/), I always wanted to learn the language, or at least functional programming part of it. I did a failed attempt the same day evening! Yesterday, I started again with the tutorials. I am sharing some of my learnings here.

**Elixir Language**

Elixir is a simple, easy to learn functional programming language build on top of Erlang VM. It is a dynamic language which allows metaprogramming and can be used for building concurrent, distributed and fault-tolerant applications with hot code upgrades.

**Installing Elixir in Ubuntu/Debian**

The only prerequisite for installing Elixir is Erlang, version 17 or later. Precompiled packages are available in [Erlang Solutions website](https://www.erlang-solutions.com/downloads/download-erlang-otp). Follow the instructions on their website to install Erlang. Then, install Elixir by cloning their repository and generating binaries:

``` bash
$ git clone https://github.com/elixir-lang/elixir.git
$ cd elixir
$ make clean test
```

Make sure to add the bin directory to the PATH environment variable ( Add it to ~/.bashrc file for bash, ~/.zshrc file for ZSH ... )

``` bash
$ export PATH="$PATH:/path/to/elixir/bin"
```

This is a distilled version of installation instructions for Debian/Ubuntu users (like me!). Refer the [original version](http://elixir-lang.org/getting_started/1.html#1.1-installers) for detailed instructions.

In the next part, I'll share the basic constructs I liked in Elixir language on the first day of learning.

*References:*

- *[Elixir: Getting Started Guide](http://elixir-lang.org/getting-started/introduction.html)*
- *[Elixir Primer and Resources](http://www.whoishostingthis.com/resources/elixir/)*
- *[Elixir (Programming Language)](http://en.wikipedia.org/wiki/Elixir_(programming_language))*

Originally posted on my blog: [Elixir Language (Part 1)](https://yedhukrishnan.blogspot.com/2014/08/elixir-language-part-1.html){:target="_blank" rel="noopener"}
