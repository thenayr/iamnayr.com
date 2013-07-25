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

These are our "monkeys" visualized.  We have average circles directly in the middle with the "tall" and "short" circles on the far left and far right. If we were to draw this same program using the previous random algorithm, we would simply have random circles appearing all along the X axis with no even distribution. Let's make it happen.

Create a new Cinder application called `NormalDistribution`:
<div class="image-wrap">
<img width='814' height='636' src="http://cdn.iamnayr.com/2013/07/ex4-1.png" alt="Tinderbox setup for application 4"/>
</div>

Include the Cinder `Random.h` library in your main source file:

{% prism c++ %}
// NormalDistributionApp.cpp file
#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"
#include "cinder/Rand.h"
{% endprism %}

In your class declaration, let's create three new variables to use in our application:

{% prism c++ %}
class NormalDistributionApp : public AppNative {
  public:
  void setup();
  void mouseDown( MouseEvent event ); 
  void update();
  void draw();

  Rand generator_;
  const float sd_ = 60;
  float mean_;
  float xPos_;
    
};
{% endprism %}

`Rand generator_;` will hold our Rand object, `const float sd_ = 60;` will hold our standard deviation value, `float mean_;` our mean (average) and `float xPos_;` our circles X coordinate.  Standard deviation is determeind by the following:  Find the median of a range of numbers, find the difference between each number and the median and square it, then find the average of all hte squares and take the square root as the standard deviation.

Luckily for us Cinder provides a much simpler method to get a value along a gaussian (also known as normal) distribution.  It comes built into the `Rand.h` library that we have used in every project so far, we can access it using our `generator_` like this: `generator_.nextGaussian();`

This will be our apps `setup()` function:

{% prism c++ %}
// NormalDistributionApp.cpp file
void NormalDistributionApp::setup()
{
  gl::clear(Color(1, 1, 1));
  gl::enableAlphaBlending();

  generator_.seed(randInt());
  app::setWindowSize(600, 200);
  mean_ = getWindowWidth() / 2;
}
{% endprism %}

We've seen `gl::clear` plenty of times by now so it probably doesn't warrant any further explanation.  `gl::enableAlphaBlending();` allows us to use transparency in our drawings.  We set a random seed value `generator_.seed(randInt());`.  We set our window size and finally our mean value to exactly half of the width of the window, this is where we want our circles to show up most.

Now on to `update()` and `draw()`:

{% prism c++ %}
// NormalDistribution.cpp update()
void NormalDistributionApp::update() 
{
  float num = generator_.nextGaussian();
  xPos_ = sd_ * num + mean_;
}
{% endprism %}

First make a call to `generator_.nextGaussian();`.  The Cinder `nextGaussian();` function returns a normal distribution of random numbers with the following parameters: mean equal to zero and standard deviation of one. Since we want the mean (average) of our circles to be in the center of the screen, we have to take the gaussian value and multiply it by the standard deviation that we want then add the mean value. Let's look at what happens when we modify our standard deviation value:

Standard deviation of 50:
<div class="image-wrap">
<img width='714' height='336' src="http://cdn.iamnayr.com/2013/07/sd-50.png" alt="Standard deviation of 50"/>
</div>

Standard deviation of 100:
<div class="image-wrap">
<img width='628' height='252' src="http://cdn.iamnayr.com/2013/07/sd-100.png" alt="Standard deviation of 100"/>
</div>

It should be clear that the higher our standard deviation is, the more distributed the numbers become.  Now we just need to draw our circles to the screen:

{% prism c++ %}
void NormalDistributionApp::draw() 
{
gl::color(0, 0, 0, 0.08);
gl::drawSolidCircle(Vec2f(xPos_, app::getWindowHeight()/2), 16);
}
{% endprism %}

Notice on our `gl::color()` function we are setting a fourth attribute for alpha value.  `gl::drawSolidCircle(Vec2f(xPos_, app::getWindowHeight()/2), 16);` draws our circles with a radius of 16 pixels.

That's it!  Now we know how to work with numbers that are more realistic in the sense of randomness. We also worked with transparency for the first time by enabling alpha blending `gl::enableAlphaBlending();`, cool! Other than that, tutorial 4 should have been more a recap of what we have already learnt. You should be getting comforatable with the `setup()`, `update()` and `draw()` functions by now.
