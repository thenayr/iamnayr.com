---
layout: post
title: "Learning Cinder Tutorial 2"
categories: tutorials
date: 2013-07-18 21:41:25 -0700
type: post
---
##Learning Cinder - The Nature of Code introduction chapter: Example 2
<div class="image-wrap">
<img width="600" height="98" src="http://cdn.iamnayr.com/2013/07/learning-cinder.png" alt="Learning Cinder image" .>
</div>
The inspiration for these tutorials came from the github repos of [nathankoch](https://github.com/nathankoch/nature-of-code-cinder) and [Mathieu Guillout](https://github.com/MathieuGuillout/TheNatureOfCodeCinder). 
The [first tutorial of this series](http://www.iamnayr.com/tutorials/learn-cinder-tutorial-part-1/) covered the first example of the Nature of Code book. It touched on some core concepts of using C++ and the Cinder framework.  The second example isn't as involved, it is fairly simple in its implementation compared to the first example, has no classes and just a few variables, but helps demonstrate how random number distribution happens.
This is what we will be creating:
<div class="image-wrap">
<img width='640' height='480' src="http://cdn.iamnayr.com/2013/07/ex2-cinder.gif" alt="Cinder example application 2"/>
</div>

## Create a new cinder application

Let's again start by creating a new application using Tinderbox, you should be getting familiar with this process by now. Call this one `RandomDistribution`.

<div class="image-wrap">
<img width='728' height='552' src="http://cdn.iamnayr.com/2013/07/ex2-1.png" alt="Tinderbox app creation"/>
</div>

Your `RandomDistribution.cpp` file should look just like this:

{% prism c++ %}
// RandomDistribution.cpp file
#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class RandomDistributionApp : public AppNative {
  public:
  void setup();
  void mouseDown( MouseEvent event ); 
  void update();
  void draw();
};

void RandomDistributionApp::setup()
{
}

void RandomDistributionApp::mouseDown( MouseEvent event )
{
}

void RandomDistributionApp::update()
{
}

void RandomDistributionApp::draw()
{
  // clear out the window with black
  gl::clear( Color( 0, 0, 0 ) ); 
}

CINDER_APP_NATIVE( RandomDistributionApp, RendererGl )
{% endprism %}

Since we are again dealing with random numbers, let's include the random number library from Cinder again:

{% prism c++ %}
#include "cinder/Rand.h"
{% endprism %}

Although totally optional, I choose to include the `prepareSettings()` function more often than not as I like to have control over the starting size of my window and framerates.  Let's add it in again:

{% prism c++ %}
class RandomDistributionApp : public AppNative {
  public:
  void setup();
  void mouseDown( MouseEvent event );
  void update();
  void draw();
  void prepareSettings( Settings *settings );
};
{% endprism %}
Now let's get familiar with a new datatype available to us in the C++ standard lib, vector.  This is a different type of vector then the one we learnt about in the first [Cinder tutorial](http://www.iamnayr.com/tutorials/learn-cinder-tutorial-part-1/).  The `Vec2f` we used in the first tutorial has a specific purpose of storing positional data on the X and Y axis.  The `vector` data type that C++ gives us is what you might traditionally think of as an array.  It's elements can be accessed using indicies in the same way that you can access an array's elements.  A vector is simply a container that can change in size, typically preferred over a normal array in C++ (which has a fixed size), as it offers the best combination of ease of use and memory usage.

In our vector, each index will hold a randomly incremented number. The syntax for defining a new vector looks like this `vector<type>`

{% prism c++ %}
class RandomDistributionApp : public AppNative {
  public:
  void setup();
  void mouseDown( MouseEvent event );
  void update();
  void draw();
  void prepareSettings( Settings *settings );
  vector<int> v;
};
{% endprism %}

We will use the easy to remember variable `v` to access our vector.  

Here is our `prepareSettings()` function call, we are setting screen size and frame rate just like the first tutorial:

{% prism c++ %}
void RandomDistributionApp::prepareSettings( Settings *settings ) 
{
  settings->setWindowSize(640,480);
  settings->setFrameRate(60.f);
}
{% endprism %}

Let's utilize Cinder's `setup()` function to push some integers into our vector `v`:

{% prism c++ %}
void RandomDistributionApp::setup() 
{
  for(int i=20; i<20; i++) {
    v.push_back(0);
  }
}
{% endprism %}

The `for` loop syntax should look very similar, it's essentially the same as every other language, just note that we have to be explicit about the variable type `i` being an integer.  The `push_back()` function available to our vector will take the integer that we pass to it and add it to the end of our vector, `v.push_back(0)` is taking the number 0 and adding it to the end of our vector each loop, we do this 20 times. 

Let's move on to our `update()` function:

{% prism c++ %}
void RandomDistributionApp::update() 
{
  int index = randInt(v.size());
  v[index]+=1;
}
{% endprism %}

First we define an integer equal to a randomly selected number between 0 and the size of our vector (20).  We then access our vector and increment the selected index by 1 `v[index]+=1;`.

Let's start drawing this to our window:

{% prism c++ %}
void RandomDistributionApp::draw() 
{
  gl::clear( Color(1, 1, 1));
  int w = app::getWindowWidth() / v.size();
  for ( int i = 0; i < v.size(); i++ ) {
    Rectf bar = Rectf( i*w, app::getWindowHeight() - v[i], i*w + 30, app::getWindowHeight());
    gl::color(0.5f,0.5f,0.5f);
    gl::drawSolidRect(bar);
    gl::color(0.0f, 0.0f, 0.0f);
    gl::drawStrokedRect(bar);
  }
}
{% endprism %}

First we have the familiar `gl::clear`, let's set the background to white instead of the standard black `gl::clear( Color(1,1,1));`. The integer variable `w` is storing the total width of our window divided by the size of our vector, 640/20 leaves us with 32, we will get back to this integer shortly.  Let's look at our for loop:

{% prism c++ %}
for ( int i = 0; i < v.size(); i++ ) {
  Rectf bar = Rectf( i*w, app::getWindowHeight() - v[i], i*w + 30, app::getWindowHeight());
  gl::color(0.5f,0.5f,0.5f);
  gl::drawSolidRect(bar);
  gl::color(0.0f,0.0f,0.0f);
  gl::drawStrokedRect(bar);
}
{% endprism %}

Here we can see the `Rectf()` function for the first time. This is a Cinder `RectT` class object that takes 4 arguments, the X and Y coordinates of the top left point and the X and Y coordinates of the bottom right point then draws a rectangle between them. We set these points by first multiplying our `w` integer from earlier (32) by the current value of `i` in our for loop to first set the X value of the top left point then grabbing the taking the total height of the window with and subtracting the current index value `app::getWindowHeight() - v[i]` to set the Y value of the top left point. For the bottom right point we start by multiplying our `w` integer (still 32) by the current value of `i` and adding 30 then getting the total height of our window once again `app::getWindowHeight());`.  It's important to point out that the number 30 here is an arbitrary value that we chose to give our rectangles a width.  

<div class="image-wrap">
<img width='320' height='240' src="http://cdn.iamnayr.com/2013/07/x-y.png" alt="Graph of cinder values"/>
</div>

Let's take a step back and think of these as spatial values.  Let's pretend we are on the first of our 20 loops,  here's what our Rectf would look like: `Rectf( 0, 480, 30, 480);` This means we have one point in the very bottom left of our graph and another point 30 pixels to the right of that point. `gl::drawSolidRect(bar)` takes those two points and draws the necessary lines to create a rectangle between them.  

You can see we've used `gl::color()` several times throughout the `draw()` function. Whatever is drawn after the most recent call to `gl::color()` will inherit that color value.  In order to give our rectangles an outline and not just a fill, we also set the color to black then call `gl::drawStrokeRect(bar);` to create just the outline of our rectangle on top of the existing solid rectangle.

Here is our completed `RandomDistribution.cpp` file:

{% prism c++ %}
// RandomDistributionApp.cpp file
#include "cinder/app/AppNative.h"
#include "cinder/gl/gl.h"
#include "cinder/Rand.h"

using namespace ci;
using namespace ci::app;
using namespace std;


class RandomDistributionApp : public AppNative {
  public:
  void setup();
  void mouseDown( MouseEvent event ); 
  void update();
  void draw();
    void prepareSettings( Settings *settings );
    vector<int> v;
};

void RandomDistributionApp::prepareSettings( Settings *settings ) {
    settings->setWindowSize(640,480);
    settings->setFrameRate(60.f);
}

void RandomDistributionApp::setup()
{
    for(int i=0; i<20; i++) {
        v.push_back(0);
    }
}

void RandomDistributionApp::mouseDown( MouseEvent event )
{
}

void RandomDistributionApp::update()
{
    int index = randInt(v.size());
    v[index]+=1;
}

void RandomDistributionApp::draw()
{
  // clear out the window with white
  gl::clear( Color( 1, 1, 1 ) );
    
    int w = app::getWindowWidth() / v.size();
    
    for ( int i = 0; i < v.size(); i++ ) {
        Rectf bar = Rectf( i*w, app::getWindowHeight() - v[i], i*w + 30, app::getWindowHeight() );
        gl::color(0.5f,0.5f,0.5f);
        gl::drawSolidRect(bar);
        gl::color(0,0,0);
        gl::drawStrokedRect(bar);
        
    }
}

CINDER_APP_NATIVE( RandomDistributionApp, RendererGl )

{% endprism %}

You should now be able to run the application and see a growing series of rectangles.
