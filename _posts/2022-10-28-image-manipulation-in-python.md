---
layout: post
title: Image Manipulation in Python
date: 2022-10-28 00:00 +0000
categories: [Digital Image Processing]
tags: [python, digital-image-processing]
---

If you haven’t read the last post in the series, please read it here: [The R, G, and B in an Image](/posts/the-r-g-and-b-in-an-image/).

Let’s see how we increase/decrease the brightness or contrast of an image and some other transformations. We already know that images are NumPy arrays in Python. All we need to do now is to perform matrix operations.

Let’s start by reading a greyscale image.

![A gray tree](/assets/img/2022/grayscale-image.webp)
_Image Courtesy: pexels.com_

``` python
import numpy as np
import imageio
image = imageio.imread('grey_tree.jpg')
```

Let’s say we would like to increase the brightness of the image. To do that, add a constant value to each pixel. This is how we do that in NumPy

``` python
bright_image = image + 50
bright_image[bright_image > 255] = 255
imageio.imwrite("bright_grey_tree.jpg", bright_image.astype(np.uint8))
```

In the first line, I added 50 to each pixel value. When we do that, some pixels will go above the 8-bit image threshold of 255. When that happens, we set it back to 255, the highest possible value. Then I saved the matrix as an 8-bit image.

As you see in the snippet above, NumPy makes it easier to change all the pixel values without iterating over them in a loop. That is the beauty of the library.

If we save the image, we will see a brighter image like this:

![A bright gray tree](/assets/img/2022/bright-image.webp)

You can guess what we would do to decrease the brightness now. We need to subtract a constant value from each pixel. If the number goes negative, set it to 0.

``` python
dark_image = image - 50
dark_image[dark_image < 0] = 0
imageio.imwrite("dark_grey_tree.jpg", dark_image.astype(np.uint8))
```

And the resulting image looks like this:

![A dark gray tree](/assets/img/2022/dark-image.webp)

We can adjust the brightness in percentages too. Convert the percentage value to the pixel value using the formula:

```
pixel_value = 255 * (percentage_value / 100)
```

To adjust the contrast of an image, instead of adding or removing a constant, we multiple each pixel with a number:

``` python
high_contrast_image = image * 1.5
high_contrast_image[high_contrast_image > 255] = 255
imageio.imwrite("high_contrast_grey_tree.jpg", high_contrast_image.astype(np.uint8))
low_contrast_image = image * 0.5
low_contrast_image[low_contrast_image > 255] = 255
imageio.imwrite("high_contrast_grey_tree.jpg", low_contrast_image.astype(np.uint8)
```

Here are the corresponding versions of the image.

![A high contrast gray tree](/assets/img/2022/high-contrast-image.webp) ![A low contrast gray tree](/assets/img/2022/low-contrast-image.webp)

As you can see, multiplying by a number greater than 1 increases the contrast, while multiplying by a number less than 1 decreases the contrast.

What if you want to flip the image? All you need to do is to reverse the rows in the matrix:

``` python
flipped_image = image[::-1, :]
imageio.imwrite("flipped_image.jpg", flipped_image.astype(np.uint8)
```

![A flipped gray tree](/assets/img/2022/flipped-image.webp)

`image[::-1, :]` reverses the rows in the image `(::-1)` and keeps the columns intact (`:`). You can get the mirror image by doing the same for columns instead of rows.

I recommend going through the [NumPy docs](https://numpy.org/doc/1.23/user/absolute_beginners.html) to learn more about how these operators work. Read an image, and play around with it. Search about various matrix operations, read how you can do that with NumPy, and try them on your image. See how the image transforms when you do that.

In future posts, I will explain how we can do color image manipulation. For now, please share your feedback and thoughts about these posts.

I've also published the article on Medium: [Image Manipulation in Python](https://medium.com/@yedhu/image-manipulation-in-python-98db79cc0c1).
