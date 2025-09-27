---
layout: post
title: Introduction to Digital Image Processing in Python
date: 2019-09-29 00:00 +0000
categories: [Digital Image Processing]
tags: [python, digital-image-processing]
---

If you haven’t read the first post in the series, read it here: [Lessons on Digital Image Processing](/posts/lessons-on-digital-image-processing-1/).

In this second part, let’s write some actual code. We will be writing all our code in Python.

Python makes processing and manipulating images very easy. NumPy and SciPy packages available for Python help us to perform scientific computing, mainly operations on matrices, which is of interest to us. We already saw images are just matrices in computers.

The easiest way to install SciPy and NumPy in a Linux machine is using Python package manager pip.

``` bash
sudo apt-get install python3-pip
sudo pip3 install numpy scipy
```

Let’s install two more packages which are necessary to load and display an image in Python.

``` bash
sudo pip3 install imageio matplotlib
```

Now, to load and display an image, all you need is a few lines of code. Make sure you have an image file in the same directory where your code is residing.

``` python
import imageio
import matplotlib.pyplot as plt

# Load the image
image = imageio.imread('color_flower.jpg')

# Display the image
plt.imshow(image)
plt.show()
```

That’s all. The code is self-explanatory. I have added necessary comments to help you understand.

We have a color image. How do we create a greyscale image from it?

We already know a color image has three values in each pixel positions for representing red, green and blue intensity values. In a greyscale image, there is only one value. All we need to do is to convert these three values into a single value.
How do we do that?

Just take the average of all the three values!

```
grey pixel value = (red + green + blue) / 3
```

Let us implement this in Python. We use a NumPy array to store the image in Python. NumPy provides a convenient function to take the average or mean on any axis. In the case of an RGB image, axis = 0 is row-wise, axis = 1 is column-wise and axis = 2 is channel-wise. We need a channel-wise sum.

```
gray_image = image.mean(axis = 2)
```

This one line of code converts the color image to a grayscale image. It does the same thing as the following lines of code:

``` python
(row, col, _) = image.shape

# Define an empty array for grey image
grey_image = np.zeros((row, col))

for i in range(row):
    for j in range(col):
        # Store the average of R, G, B values
        grey_image[i, j] = image[i, j].mean()

plt.imshow(grey_image, cmap='gray'); plt.show()
```

The above code is much slower than the previous version. However, understanding this is important if you are new to this.

We just created the grey version of the image. Now, we can convert this into a binary image. A grey image pixel values range from 0 to 255. In binary, it can take only two values. In some representations, we use 0 and 1. Here, we’ll use 0 (for black) and 255 (for white).

How do we convert a grey image into a binary image? The usual method is to set a threshold value T. If the pixel value is above the threshold, we’ll set it to 255. If it is below, we’ll set it to 0. Here, we can take the threshold as the median grey value, which is 128.

Here is the extended version of the code.

``` python
binary_image = np.zeros((row, col))

for i in range(row):
    for j in range(col):
        if grey_image[i, j] <= 128:
            pixel = 0
        else:
            pixel = 255

        binary_image[i, j] = pixel

plt.imshow(binary_image, cmap='gray'); plt.show()
```

And the short version is just two lines:

```
binary_image = grey_image.copy()
binary_image[binary_image <= 128] = 0
binary_image[binary_image > 128]  = 255
```

That is it! NumPy takes care of updating all the pixel values to 0 or 255 depending on whether they are above or below the threshold.

Now we know about color, greyscale and binary images, and we know how to convert a color image to grey and then to binary. We will see more image processing techniques and python code in the upcoming posts.

For now, please share your feedback and opinion about these posts.

Originally published on Medium: [Introduction to Digital Image Processing in Python](https://medium.com/analytics-vidhya/lessons-on-digital-image-processing-2-983d8bab98c8).
