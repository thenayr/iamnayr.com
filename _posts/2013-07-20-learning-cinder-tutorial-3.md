---
layout: post
title: "Learning Cinder Tutorial 3"
categories: tutorials
date: 2013-07-20 08:55:21 -0700
type: post
---
##Learning Cinder - The Nature of Code introduction chapter: Example 3
<div class="image-wrap">
<img width="600" height="98" src="http://cdn.iamnayr.com/2013/07/learning-cinder.png" alt="Learning Cinder image" .>
</div>
In tutorial 3, we are going to revisit the concept of a "walker", quite similar to the first example, only this time we will coax our walker to favor walking in a certain direction, as opposed to complete randomness of the first walker.  You will also be introduced to pointers in C++ and how to access the member functions of a class when using pointers.
<div class="image-wrap">
<img width='640' height='502' src="http://cdn.iamnayr.com/2013/07/cinder-ex3.gif" alt="Cinder example application 3"/>
</div>

Fire up Tinderbox and create a new app, let's name it "RightWalker".
<div class="image-wrap">
<img width='814' height='636' src="http://cdn.iamnayr.com/2013/07/ex3-1.png" alt="Tinderbox setup for application 3"/>
</div>

Let's hop right in to creating our class for the walker.  Right click on the Headers folder and create a new class called "Walker", drag the `Walker.cpp` file into the source directory.

<div class="image-wrap">
<img width='640' height='480' src="http://cdn.iamnayr.com/2013/07/ex3-1.gif" alt="Creating a new class in Xcode"/>
</div>

Here is the `Walker.h` file:

{% prism c++ %}
// Walker.h file
#pragma once
#include "cinder/app/AppBasic.h"
#include "cinder/Rand.h"

typedef std::shared_ptr<class Walker> WalkerRef;
class Walker {
public:
    Walker();
    void update();
    void draw();

private:
    float x_;
    float y_;
    int radius_;

};
{% endprism %}

You'll see this time we have variables both in the `public:` and `private:` namespaces.  This line probably stands out as well `typedef std::shared_ptr<class Walker> WalkerRef;`.  Here we are assigning the pointer `WalkerRef` to our class Walker (specifically a "smart" pointer). Well these are a complicated subject and somewhat beyond the scope of this tutorial, just know that the main benefit of using a `shared_ptr` is for memory management.  A shared pointer will keep track of each instance of our object and automatically delete it once it is no longer being used.  

The `typdef` keyword just before the `std::shared_ptr` is telling our application that we want to be able to access our `shared_ptr<class Walker>` simply by using the keyword `WalkerRef`, think of it as an alias or synonym to our object.

Aside from that, the only difference in this Walker class in comparison to the [first Cinder tutorial](http://www.iamnayr.com/tutorials/learn-cinder-tutorial-part-1/) is that we have variables under a `private:` namespace here.  This means we can only have access to these variables when we are referencing member functions in our class directly.  We can't, for instance, set the variable `float x_;` directly in our `setup()` function. We must access it through whichever function in our Walker class is in charge of modifying it.  This might sound strange at first, but it is pretty common practice to make all of your class variables private, it eliminates confusion later on and makes accessing variables an explicit task.

Let's start writing our `Walker.cpp` file now:

{% prism c++ %}
#include "Walker.h"

using namespace ci;
using namespace std;

Walker::Walker() {
    Vec2f center = app::getWindowCenter();
    x_ = center.x;
    y_ = center.y;
    radius_ = 3;
}
{% endprism %}

We start by including our `Walker.h` file as usual.  This time we will actually have our contructor set some initial variables for us.  Remember, our constructor always takes on the same name as our class and gets called whenever you instantiate a new object of that type.  

{% prism c++ %}
// Walker constructor
Walker::Walker() {
  Vec2f center = app::getWindowCenter();
  x_ = center.x;
  y_ = center.y;
  radius_ = 3;
}
{% endprism %}

If you remember in the first tutorial, instead of using a constructor we created an `init()` function that was responsible for setting the initial starting point of our walker.  Here we see a much easier way to get our starting point.  First we create a `Vec2f` name center and run the Cinder function `app::getWindowCenter()`.  In order to access the individual x and y coordinates of the Vec2f we use dot notation.  `center.x` returns the x coordinate and `center.y` returns the y coordinate.  We assign these values to `x_` and `y_` respectively.  Finally we set a variable `radius_` equal to an arbitrary value of 3.

{% prism c++ %}
// Walker.cpp update function
void Walker::update() {
  Rand::randomize();
  float r = randFloat();
  if (r < 0.4) {
    x_ += 5;
  } else if (r < 0.6) {
    x_ -= 5;
  } else if (r < 0.8) {
    y_ += 5;
  } else {
    y_ -= 5;
  }

  if (x_ >= app::getWindowWidth()) {
    x_ -= 5;
  }
}
{% endprism %}

Our `update()` function looks very similar to the last walker `update()` function.  We grab a random floating value between 0 and 1 with `float r = randFloat();` then do some control statements to make our walker move in certain directions based on the value assigned.  You'll notice our walker has the highest chance of moving in the postive x direction because our first check is `r < 0.4`, that means any value between 0.0 and 0.4 will make our walker step right (a 40% chance of moving right), while the other 3 directions only have a 20% chance of moving in their respective direction. We also add an out of bounds check to see if our walker has gone beyond the width of the window, if so we move it back 5 pixels.  This should create the effect of our walker moving to the right then hitting a wall.

Last but not least is our walker's `draw()` function:

{% prism c++ %}
// Walker.cpp draw function
void Walker::draw() {
  gl::color(Color(0,0,0));
  gl::drawSolidCircle(Vec2f(x_, y_), radius_);
}
{% endprism %}

We just set our drawing color to black and draw a circle on our current `x_` and `y_` values using the radius `radius_`.

Here is the entire `Walker.cpp` file:

{% prism c++ %}
// Walker.cpp file
#include "Walker.h"

using namespace ci;
using namespace std;

Walker::Walker() {
    Vec2f center = app::getWindowCenter();
    x_ = center.x;
    y_ = center.y;
    radius_ = 3;
}

void Walker::update() {
    Rand::randomize();
    float r = randFloat();
    if (r < 0.4) {
        x_ += 5;
    } else if (r < 0.6) {
        x_ -= 5;
    } else if (r < 0.8) {
        y_ += 5;
    } else {
        y_ -= 5;
    }

    if (x_ >= app::getWindowWidth()) {
      x_ -= 5;
    }
}

void Walker::draw() {
    gl::color(Color(0,0,0));
    gl::drawSolidCircle(Vec2f(x_, y_), radius_);
}
{% endprism %}

Now let's string it all together in our `RightWalkerApp.cpp` file and make it work:

{% prism c++ %}
//RightWalkerApp.cpp file
#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"
#include "Walker.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class RightWalkerApp : public AppNative {
  public:
  void setup();
  void mouseDown( MouseEvent event ); 
  void update();
  void draw();
    
  private:
    WalkerRef w_;
};

void RightWalkerApp::setup()
{
    gl::clear(Color(1, 1, 1));
    w_ = WalkerRef(new Walker());
}

void RightWalkerApp::mouseDown( MouseEvent event )
{
}

void RightWalkerApp::update()
{
    w_->update();
}

void RightWalkerApp::draw()
{
  w_->draw();
}

CINDER_APP_NATIVE( RightWalkerApp, RendererGl )
{% endprism %}

First remember to `#include Walker.h` file at the top!  In our class declaration we add a `private:` namespace and assign our pointer WalkerRef to a new variable `w_`.  Our `setup()` function we set the background color to white and create a new Walker object with `w_ = WalkerRef(new Walker());`, this triggers our classes constructor which is responsible for setting our initial starting point and radius values.  

Since we are now interfacing with a pointer, we use an arrow to access the functions of that class.  In our `RightWalkerApp::update()` function we call `w_->update();` to access the update function of our walker.  

The same goes for `RightWalkerApp::draw()`, we call `w_->draw()` to access the draw function of our walker class.

Try building your application now.

## Tutorial 3 Recap
We used a shared_ptr for the first time and learned how to access our functions using the arrow `->`.  We also learnt a shortcut function for getting the center point of our window `Vec2f center = app::getWindowCenter()` from which we can access the individual coordinates using `center.x` and `center.y`.  Finally we used probability to influence a particular event to occur (in our case our walker to move right).
