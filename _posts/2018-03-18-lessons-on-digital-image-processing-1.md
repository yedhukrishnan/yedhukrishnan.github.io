---
layout: post
title: Lessons on Digital Image Processing
date: 2018-03-18 22:31 +0530
categories: [Digital Image Processing]
tags: [python, image-processing]
---

This is the first one of a series of posts I am planning to write about image processing. I intend this post for students who are new to the concepts of image processing. The code snippets, if there are any, will be in simple Python. If you want to learn Python, there is an [interactive tutorial here](https://www.learnpython.org/). You can also check out [Python tutorial](https://docs.python.org/3/tutorial/) on the official website.

There is always room for improving these posts. I would like to read your comments and feedback about the series.

## Digital Image

Let’s start with the basic concept of image processing. A digital image can be represented as a matrix, a rectangular array of integers called [pixels](https://en.wikipedia.org/wiki/Pixel). Each pixel represents a small color box.

Consider a small matrix of size 2 x 2, where each is represented with an 8-bit integer. So, the values can range from 0 to 255 (²⁰ to ²⁸-1). Consider a simple example given below.

```
255  0
0    255
```
The image represented by the above matrix looks like this.

![The 2x2 image](/assets/img/2018/2x2_image.webp)
_The 2x2 image_

Here, the value 255 represents a white color, while 0 represents a black. This is a [bilevel or binary image](https://en.wikipedia.org/wiki/Binary_image). Each of the values in the matrix is a pixel, the smallest units of an image. In some cases, the binary images are represented with a single bit. In some cases, 0 represents black and 1 represents white, or vice versa.

This is just an enlarged representation of 4 pixels in an image. In a real case, the pixels are tiny, and you can represent complex figures with larger matrices. In fact, if the number of pixels per inch increases, the quality of the image increases. The same concept is used in mobile phone and computer displays.


![The 853x1280 binary image of a flower](/assets/img/2018/binary_image.webp)
_A 853x1280 binary image of a flower (courtesy: pixabay.com)_

As you might be already thinking, binary images do not represent actual images we see. In reality, there should be more colors than just black and white. How do we represent that?

We already mentioned that the pixel values are 8 bits. They can take any value between 0 and 255. As the value increases from 0 to 255, the color changes from black to grey to white. In total, there are 256 shades of grey! Such an image is called a [grayscale image](https://en.wikipedia.org/wiki/Grayscale).

![The same flower image in greyscale](/assets/img/2018/grayscale_image.webp)
_The same flower image in greyscale, where each pixel value ranges from 0 to 255 (courtesy: pixabay.com)_

But where are the colors? We stumble upon color images more often than grey images. That is where the color theory comes into the picture. We know the white light can be formed from three primary colors: red, green and blue. These three primary colors can be mixed in different ratios to get different colors.

The same technique is used in digital images. So far, we have seen pixels with just one value. In a color image, each pixel takes three values, one for red, green and blue. All these values range from 0 to 255. This gives us a total of 255 * 255 * 255 possible combinations of colors, which is also known as 16 million colors. Imagine a color image as three greyscale matrices stacked together, where the matrices represent these three color channels.


![The same flower image in color](/assets/img/2018/color_image.webp)
_Much better! Here, each pixel is a combination of three values, representing R, G and B (courtesy: pixabay.com)_

The color model described here is known as an [RGB model](https://en.wikipedia.org/wiki/RGB_color_model). There are other models as well. But for now, let us stick with this one. In the upcoming posts, I will explore more topics in digital image processing. I will also include simple algorithms implementations in Python.

For now, please share your feedback and opinion. I would definitely improve based on that.

I've also published the article on Medium: [Lessons on Digital Image Processing (#1)](https://medium.com/analytics-vidhya/lessons-on-digital-image-processing-1-b7a1fa3acfe9).

