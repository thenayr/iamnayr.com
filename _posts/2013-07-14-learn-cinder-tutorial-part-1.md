---
layout: post
title: "Learning Cinder part 1"
date: 2013-07-14 14:24:52 -0700
categories: tutorials
type: post
---
## Learning Cinder - The Nature of Code introduction chapter: Example 1
This is the first of the Learning Cinder tutorial series. This tutorial will cover the first example from the Introduction chapter of The Nature of Code. Please feel free to [reference that chapter here](http://natureofcode.com/book/introduction/).  In this example we will be utilizing a fundamental tool in the creative coders toolbelt, the ability to generate randomness.  Our specific implementation will be a "Walker" class that moves a circular point on screen either randomly in one of 4 directions: up, down, left or right. It looks a bit like this:  
<div class="image-wrap">
<img height="480" width="644" src="http://cdn.iamnayr.com/2013/07/ex1.gif" alt="Learning Cinder introduction example 1"/>
</div>  

## Create a new Cinder app using Tinderbox
Tinderbox is a great little utility that comes packaged with Cinder that makes it super easy to get a basic Cinder application running.  Remember, Cinder is simply a C++ Library, there is no built-in IDE like you might get with processing.  Tinder will create the basic framework (file structure, imports, etc) that all Cinder apps use. Open Tinderbox and call your new project "RandomWalker".

<div class="image-wrap">
<img width='728' height='552' src="http://cdn.iamnayr.com/2013/07/ex1-1.png" alt="Tinderbox app creation"/>
</div>

## Open the Xcode application file
Clicking 'next' then 'finish' should open the newly created applications folder in your finder.  Now navigate into the xcode directory and open the RandomWalker.xcodeproj file. Xcode usage is a bit beyond the scope of these tutorials as well, I'm not expecting you to be super familiar with it, it's a very powerful IDE, but for the sake of these tutorials we will only be using its basic functionality which is to compile the code we are writing and run it for us. You should see something similar to the following: 
<a href="http://cdn.iamnayr.com/2013/07/ex1-2.png"><img  src="http://cdn.iamnayr.com/2013/07/ex1-2.png" alt="Xcode simple application"/></a>

You can run the app as-is right now by hitting cmd+R and you should get a simple black screen that does a whole lot of nothing, great! Exciting stuff.
<div class="image-wrap">
<a href="http://cdn.iamnayr.com/2013/07/ex1-3.png"><img  src="http://cdn.iamnayr.com/2013/07/ex1-3.png" alt="First Cinder application"/></a>
</div>

## A brief introduction to Cinder's built in functions
Cinder comes pre-defined with several important functions.  Every Cinder project you ever create is made up of three main functions, these are setup(), update() and draw().  setup() is run only once, when you first start your program, update() and draw() are run for every frame of your application, first update() then draw(). There is an optional method called prepareSettings() which allows you to customize your application settings like framerate and window size. These are pretty self explanatory. Just remember, setup() runs once at the beginning, then update() + draw() every frame after that. Simple. 

## Creating our Walker class
Great now let's move on to creating the class files for our Walker.  You can do this by right-clicking on the headers directory in the Xcode file browser and selecting "new file" followed by "C++ class" as the template type. 

<div class="image-wrap">
<a href="http://cdn.iamnayr.com/2013/07/ex1-4.png"><img  src="http://cdn.iamnayr.com/2013/07/ex1-4.png" alt="Creating a new class file"/></a>
</div>

<div class="image-wrap">
<a href="http://cdn.iamnayr.com/2013/07/ex1-5.png"><img  src="http://cdn.iamnayr.com/2013/07/ex1-5.png" alt="Name the class file Walker"/></a>
</div>

Lets name it "Walker".  You'll notice this creates two files in the headers directory, Walker.h and Walker.cpp. C++ classes are split into two seperate files, this probably seems weird at first, at least it did for me, but it really makes organization better and keeps our code looking nice. The .h file or header, is also called the interface file.  It can be thought of as the skeleton of our class.  It includes definitions of the data members (or variables) and the member functions. The .cpp file, or implementation file, includes the actual code for the class functions.

Now that we have a basic understanding of how a C++ class is organized, let's start implementing.  For the sake of cleanliness let's drag the Walker.cpp file down into the source directory and only leave the Walker.h file in the headers directory.  

<div class="image-wrap">
<a href="http://cdn.iamnayr.com/2013/07/ex1-6.png"><img  src="http://cdn.iamnayr.com/2013/07/ex1-6.png" alt="Move the .cpp file to the source directory"/></a>
</div>

Go ahead and delete everything that currently exists in the Walker.h file, Xcode throws in a bunch of C++ boilerplate that we aren't really going to use with Cinder. 
<div class="image-wrap">
<a href="http://cdn.iamnayr.com/2013/07/ex1-7.png"><img  src="http://cdn.iamnayr.com/2013/07/ex1-7.png" alt="Remove C++ boilerplate"/></a>
</div>

Now we have a nice bare header file to start defining our class with.  You've probably noticed by now that C++ shares a similar syntax for comments with many other languages, the `//comment` style.  

```c++
//Walker.h file

#pragma once

class Walker {
  public:
    Walker();
    void step();
    void display();
    void init();
    int x_, y_;
}
```

You're probably wondering what the hell this line means: 

```c++
#pragma once 
```

Don't worry, it's the C++ way to tell the compiler to only compile this class one time... or something like that.  Don't get too distracted by it right now.  You'll be seeing it plenty.

Let's talk about the rest of the code.  

```c++ 
//Walker.h file

class Walker {
  public:
    Walker();
    void step();
    void display();
    void init();
    int x_, y_;
}
```
Here we are simply writing out the definitions of our class in the interface file.  Everything goes under the `public:` namespace because we want to be able to access these variables and functions global.  This is slightly different then say, Java, where you identify every member as public or private.  C++ standards would probably dictate that our classes member variables should be under the `private:` namespace and only be accessed by our classes functions, but for the sake of simplicity we will simply put everything under `public:` for now. The `void` in front of each of our functions simply means they don't have a return value, but rather just change one of our variables or draw to the screen.

`int x_, y_;` Here we are simply defining two integer variables called x_ and y_ that we will use to move our Walker along the x axis and y axis.

Now we have a neatly organized skeleton of a class, let's see what our implementation files looks like, again delete the boilerplate code that Xcode has stuck in there:

```c++
//Walker.cpp file

// Include the necessary cinder libraries
#include "cinder/app/AppBasic.h"
#include "cinder/Vector.h"
#include "cinder/Rand.h"
// Include our classes interface (header) file
#include "Walker.h"

using namespace ci;

Walker::Walker() 
{
}

void Walker::init() { 
  x_ = app::getWindowWidth()/2;
  y_ = app::getWindowHeight()/2;
}

void Walker::step() {
  Rand::randomize();
  int xstep = ( Rand::randInt(0,3)-1 )*5;
  int ystep = ( Rand::randInt(0,3)-1 )*5;
  x_ += xstep;
  y_ += ystep;
}

void Walker::display() {
  gl::color(0,0,0);
  gl::drawSolidCircle( Vec2f(x_,y_),3 );

  if ( x_ >= app::getWindowWidth() ) {
    x_ = 0-3;
  } else if ( x_ < 0 ) {
    x_ = app::getWindowWidth()+3; 
  } else if ( y_ >= app::getWindowHeight() ) {
    y_ = 0-3;
  } else if ( y_ < 0 ) {
    y_ = app::getWindowHeight()+3; 
  }
}
```
We have a lot more going on here than in the interface file, you are probably starting to see the benefit of separting the interface from the implementation.  Let's go over some of the code. 

We start by simply importing the libraries that are necessary for our class to function and use the helpers provided by Cinder.  At the bottom of the includes is our Walker.h file.

```c++
//Walker.cpp file

// Include the necessary cinder libraries
#include "cinder/app/AppBasic.h"
#include "cinder/Vector.h"
#include "cinder/Rand.h"
// Include our classes interface (header) file
#include "Walker.h"
```

Next we have this strange looking line `using namespace ci;`. In c++ you can give your namespaces an alias.  This is simply a shorter way to avoid having to write cinder:: in front of everything, cinder provides a nice simple alias for us to use.

`Walker::Walker(){}` is our constructor.  I assume you have some familiarity with writing classes in any language, this is simply the function that gets called when a new object of our class type gets instantiated.  Ours does nothing for now.

The following is our first function that actually does something, the init function.  Again it's important to mention that this function can be called anything, I simply choice to go with init as you will see later that it gets called in the cinder `setup()` function.

```c++
void Walker::init() { 
  x_ = app::getWindowWidth()/2;
  y_ = app::getWindowHeight()/2;
}
```
The purpose of the init function is simply to set the initial position of our Walker.  We want our circles to start in the middle of the screen, so we first set the `x_` variable equal to half of the screen width, or `app::getWindowWidth()/2`.  `app::getWindowWidth()` is a method built into Cinder that simply gives us the current width of the window, dividing that by two gives us the center point on the x axis. We do the same for the screen height.

```c++
void Walker::step() {
  Rand::randomize();
  int xstep = ( Rand::randInt(0,3)-1 )*5;
  int ystep = ( Rand::randInt(0,3)-1 )*5;
  x_ += xstep;
  y_ += ystep;
}
```
Our `step()` function is responsible for increment our `x_` and `y_` variables by one of three randomly selected values (-5,0,5). We first call `Rand::randomize()` to generate a random, random seed number (very meta).  We then create two seperate integer variables named xstep and ystep and assign them a value of either -1,0 or 1 which we then multiply by 5 to get bigger steps. The `Rand::` namespace (whos library we imported earlier) provides us with the ability to generate random numbers, here we used the `randInt` method which takes a range of values from which to select a random number. Once we have our random integers, we then add those to the current postion of `x_` and `y_`.  Easy.  If `x_` starts out in the middle of the screen and our xstep = 5, then our circle would move 5 pixels to the right.  Remember though, the `step()` function is only modifying our variables, not actually drawing or moving anything on the screen.  
