---
layout: post
title: Functional Programming (Part 1)
date: 2015-05-02 12:38 +0530
categories: [Functional Programming]
tags: [functional-programming]
---

I've been talking about Elixir for a while. It's never too late, but I believe it's high time to share what I learned about functional programming and why is it important.

Let's start with the fundamental difference. In an object oriented world, we solve the problem using classes and objects. A class depicts a behaviour while an object stores a state. While solving a problem, a lot of time is wasted modelling classes and hierarchies. But in a real world, we want to get things done than spending time maintaining states. This is what makes functional programming different. While the imperative style of programming concentrates on *what* and *how* to get things done, functional programming concentrates only on *what*. How is it being done, we don't need to worry about that.

In functional programming, we never mutate data. We just transform them. What's the big deal if we change some existing data? Here is the simplest explanation: We don't need to worry about data inconsistencies in a multi-threaded environment. It's always ensured that nobody is going to touch the data created by us.

Originally posted on my blog: [Functional Programming (Part 1)](https://yedhukrishnan.blogspot.com/2015/05/functional-programming-part-1.html){:target="_blank" rel="noopener"}
