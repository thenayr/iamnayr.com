---
layout: picture
title: "Processing 1"
categories: pictures
type: picture
date: 2013-05-16 19:19:30 -0700
excerpt: blank
---

![First generated image in processing](http://cdn.iamnayr.com/2013/05/2013-05-16--1368757019_1281x732_scrot.png)

{% highlight java %}

void setup() {
  size(1280,720);
  smooth();
  frameRate(120);
}
int x = 0;
int y = 0;

void draw() {
  ellipse(x,y,10,10);
  x += 10;
  if (x>width) {
    x = 0;
    y += 5;
  }
  if (y>height/3) {
    fill(250,105,0);
    stroke(255);
  }
}
{% endhighlight %}

