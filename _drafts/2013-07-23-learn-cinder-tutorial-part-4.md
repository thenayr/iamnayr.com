---
layout: post
title: "Learning Cinder part 4"
categories: tutorials
date: 2013-07-23 12:10:29 -0700
type: post
---
##Learning Cinder - The Nature of Code introduction chapter: Example 4
<div class="image-wrap">
<img width="600" height="98" src="http://cdn.iamnayr.com/2013/07/learning-cinder.png" alt="Learning Cinder image" .>
</div>
In tutorial 4, we will learn how Cinder handles normal distribution of Random numbers.  This paragraph from [The Nature of Code](http://natureofcode.com/book/introduction/) explains what we mean by this:
>  Pick any person off the street and it may appear that their height is random. Nevertheless, it’s not the kind of random that random() produces. People’s heights are not uniformly distributed; there are a great deal more people of average height than there are very tall or very short ones. To simulate nature, we may want it to be more likely that our monkeys are of average height (250 pixels), yet still allow them to be, on occasion, very short or very tall. A distribution of values that cluster around an average (referred to as the “mean”) is known as a “normal” distribution. It is also called the Gaussian distribution (named for mathematician Carl Friedrich Gauss) or, if you are French, the Laplacian distribution (named for Pierre-Simon Laplace). Both mathematicians were working concurrently in the early nineteenth century on defining such a distribution.



<div class="image-wrap">
<img width='602' height='226' src="http://cdn.iamnayr.com/2013/07/noc-ex4.gif" alt="Normal random number distribution"/>
</div>

These are our "monkeys" visualized.  We have an average circle directly in the middle with the "tall" and "short" circles on the far left and far right. If we were to draw this same program using the previous random algorithm, we would simply have random circles appearing all along the X axis with no even distribution. Let's make it happen.


