---
layout: post
title: Tower of Hanoi
date: 2015-08-25 23:06 +0530
categories: [Algorithms]
tags: [elixir, recursion, algorithms, programming, mathematics]
---

Tower of Hanoi is a recurrent mathematical problem. In recurrence, the solution to each problem depends on the solutions to smaller instances of the same problem.

I'd solved this problem a few years ago. But now, since we talk about functional programming, I decided to solve the problem using Elixir.

Read more about the problem statement here: [Tower of Hanoi](http://mathworld.wolfram.com/TowerofHanoi.html)

If you want to try it interactively, [go here](https://www.mathsisfun.com/games/towerofhanoi.html).

Here is my solution:

``` elixir
defmodule TowerOfHanoi do
  def move(1, source, destination, intermediate) do
    IO.puts ["Move ", source, " to ", destination]
  end

  def move(no_of_disks, source, destination, intermediate) do
    move(no_of_disks - 1, source, intermediate, destination)
    IO.puts ["Move ", source, " to ", destination]
    move(no_of_disks - 1, intermediate, destination, source)
  end
end
```

I'm updating my GitHub repository ([yedhukrishnan/mathematics](https://github.com/yedhukrishnan/mathematics)) with more math problems. Feel free to check them out to suggest improvements or to give comments.

Originally published on my blog: [Tower of Hanoi](https://yedhukrishnan.blogspot.com/2015/08/tower-of-hanoi.html)
