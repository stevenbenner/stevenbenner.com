---
title: 'Calculate page size and view port position in JavaScript'
description: 'In this article I will show you how I perform browser view port size calculation in JavaScript. With details on how to support all modern (and not so modern) browsers with one function.'
slug: 2010/04/calculate-page-size-and-view-port-position-in-javascript
pubDate: 2010-04-25T23:45:50Z
modDate: 2010-04-25T23:58:16Z
transitory: true
image:
  src: '../../assets/thumbnails/page-size-code.png'
  alt: 'Screenshot of JavaScript code'
categories:
- Web Development
tags:
- How-To
- JavaScript
---

Have you ever had to try to figure out the *dimensions of a page* or browser in *JavaScript*? This task seems very simple at first glace, every browser has simple properties that will give you this information. Unfortunately, not every browser agrees what object these properties belong to, or even what the names are.

I’ve built a couple nifty tools in JavaScript that need to know the exact dimensions of the *document* as well as the exact dimensions of the *browser view port*. Since these scripts are uses on very high traffic sites with a very wide audience I have had to make sure they work in a multitude of browsers.

In this article I will show you how I support all modern (and not so modern) browsers with one function and I will explain a little about exactly what techniques I’m using to accomplish this.

<!-- more -->

### When do you need to know page and view port dimensions?

Basically, whenever you are going to dynamically place absolute positioned elements on the document. I have built several JavaScript features that needed to know this information.

One good example is a Lightbox/Thickbox style image viewer. You need to place a box in the exact middle of the *view port* and have the ability to shrink it down to fit within the view port constraints.

An even better example was a pop up image thumbnail feature. When you put your mouse over certain links a thumbnail pops up to show you a picture or the logo of the link you’re about to click on. This image follows the mouse around, hanging just below and to the left of the cursor. Since I could never say for sure where the links will be on the page I have to know when the flip the image to the other side of the mouse to keep it from extending past the view port.

### Dimensions needed for placement

<figure>

![View Port Example](../../assets/postimages/view-port-example.png)

</figure>

To do any kind of dynamic absolute placement you need to know what your constraints will be. These bounds are generally going to be the browser view port, which is literally the browsers current view of your document, but it is a little more complex than that.

Think of the web browser as a window and the document as a paper underneath it. When you scroll down a page you are simply moving the document up in the view port. This means that if you want to position something based on the view port you will need to consider where the view port is on the page.

Horizontal bounds are simple (assuming you aren’t dealing with a very small browser), your constraints will be *<var>X</var>=0 to <var>X</var>=<var>View Port Width</var>*. Vertical bounds are a little more complicated. To compute vertical bounds on a page you have to factor in the current scrolled position of the view port in the document. So your vertical constraints will be *<var>Y</var>=<var>View Port Offset</var> to <var>Y</var>=<var>View Port Offset</var> + <var>View Port Height</var>*. Simple.

However those formulas are missing one critical piece that most browsers do not give you, scroll bar width. Most browsers consider the scroll bars to be inside of the view port so they are not factored in to the view port dimensions that the browsers will give you. If you create an element and push it in to a scroll bar it will increase the size of the document as the browser renders it, this leads to the “infinite scrolling phenomena”. Unfortunately the width of the scroll bars depends on the operating system.

It is basically impossible to compute the size of the scroll bars in such situations, so I picked an arbitrary number that seems to have appropriate padding on every systems that I’ve tested, 17 pixels.

Taking the 17 pixel padding into consideration our bounding formula now looks like this:

 * <var>X</var> = 0 to <var>X</var> = <var>View Port Width</var> − 17
 * <var>Y</var> = <var>View Port Offset</var> to <var>Y</var> = <var>View Port Offset</var> + <var>View Port Width</var> − 17

### The browser properties

Basically every browser except *Internet Explorer* agrees where the dimensions information is located. Can’t say that I’m particularly surprised, Microsoft has made it their mission to complicate these things.

For a nice visual list of available properties and browser support check out the [W3C DOM CSS Object Model Compatibility](http://www.quirksmode.org/dom/w3c_cssom.html) article on QuirksMode. It’s a very nice list of many useful properties and methods as well as a chart of what browsers support them and how effective their support is.

#### View port dimensions

I found three possible objects that contain the view port size information. In most browsers the `self` object has the properties of `innerWidth` and `innerHeight`. However Internet Explorer has two other objects, IE6 keeps this information in the `document.documentElement` object and all new IEs use the `document.body` object. These objects have a `clientWidth` and `clientHeight` property.

#### Document dimensions

Once again, I found three different ways to get the document measurements. Most browsers agree that this information is stored in the `document.body` object. However Firefox’s best measurement of total document height seems to be `window.innerHeight + window.scrollMaxY`. The rest of the browsers respond to the `scrollWidth/scrollHeight` or `offsetWidth/offsetHeight`.

#### Scroll offset

Last but not least is the scroll offset, and again three different possible locations for this information. The general consensus is that scroll offset can be found in the `pageYOffset` and `pageXOffset` properties of the `self` or `window` objects. However IE uses `scrollTop` and `scrollLeft` properties on the `document.body` or `document.documentElement` objects.

### Short documents

One scenario that we need to be able to handle is that of a small document. If the document is smaller than the view port, such as a short page that doesn’t extend further down past the browser view, then we don’t want to use the document as our bounding constraints, we want to use the view port.

We do this by adding a simple test to see if if the view port height is greater than the document height and another test to see if the view port width is greater than the document width. In each case if it is greater then use the view port dimension instead of the document dimension.

### The code

Here is the JavaScript code that I came up with. It is fairly short and simple and uses object detection, because you should always check for objects, never check for browsers.

This code is based on the work posted on QuirksMode some 6 years ago. The article has long since disappeared so I can’t give a better credit.

```javascript
// Page Size and View Port Dimension Tools
// https://stevenbenner.com/2010/04/calculate-page-size-and-view-port-position-in-javascript/
if (!sb_windowTools) { var sb_windowTools = new Object(); };

sb_windowTools = {
	scrollBarPadding: 17, // padding to assume for scroll bars

	// EXAMPLE METHODS

	// center an element in the viewport
	centerElementOnScreen: function(element) {
		var pageDimensions = this.updateDimensions();
		element.style.top = ((this.pageDimensions.verticalOffset() + this.pageDimensions.windowHeight() / 2) - (this.scrollBarPadding + element.offsetHeight / 2)) + 'px';
		element.style.left = ((this.pageDimensions.windowWidth() / 2) - (this.scrollBarPadding + element.offsetWidth / 2)) + 'px';
		element.style.position = 'absolute';
	},

	// INFORMATION GETTERS

	// load the page size, view port position and vertical scroll offset
	updateDimensions: function() {
		this.updatePageSize();
		this.updateWindowSize();
		this.updateScrollOffset();
	},

	// load page size information
	updatePageSize: function() {
		// document dimensions
		var viewportWidth, viewportHeight;
		if (window.innerHeight && window.scrollMaxY) {
			viewportWidth = document.body.scrollWidth;
			viewportHeight = window.innerHeight + window.scrollMaxY;
		} else if (document.body.scrollHeight > document.body.offsetHeight) {
			// all but explorer mac
			viewportWidth = document.body.scrollWidth;
			viewportHeight = document.body.scrollHeight;
		} else {
			// explorer mac...would also work in explorer 6 strict, mozilla and safari
			viewportWidth = document.body.offsetWidth;
			viewportHeight = document.body.offsetHeight;
		};
		this.pageSize = {
			viewportWidth: viewportWidth,
			viewportHeight: viewportHeight
		};
	},

	// load window size information
	updateWindowSize: function() {
		// view port dimensions
		var windowWidth, windowHeight;
		if (self.innerHeight) {
			// all except explorer
			windowWidth = self.innerWidth;
			windowHeight = self.innerHeight;
		} else if (document.documentElement && document.documentElement.clientHeight) {
			// explorer 6 strict mode
			windowWidth = document.documentElement.clientWidth;
			windowHeight = document.documentElement.clientHeight;
		} else if (document.body) {
			// other explorers
			windowWidth = document.body.clientWidth;
			windowHeight = document.body.clientHeight;
		};
		this.windowSize = {
			windowWidth: windowWidth,
			windowHeight: windowHeight
		};
	},

	// load scroll offset information
	updateScrollOffset: function() {
		// viewport vertical scroll offset
		var horizontalOffset, verticalOffset;
		if (self.pageYOffset) {
			horizontalOffset = self.pageXOffset;
			verticalOffset = self.pageYOffset;
		} else if (document.documentElement && document.documentElement.scrollTop) {
			// Explorer 6 Strict
			horizontalOffset = document.documentElement.scrollLeft;
			verticalOffset = document.documentElement.scrollTop;
		} else if (document.body) {
			// all other Explorers
			horizontalOffset = document.body.scrollLeft;
			verticalOffset = document.body.scrollTop;
		};
		this.scrollOffset = {
			horizontalOffset: horizontalOffset,
			verticalOffset: verticalOffset
		};
	},

	// INFORMATION CONTAINERS

	// raw data containers
	pageSize: {},
	windowSize: {},
	scrollOffset: {},

	// combined dimensions object with bounding logic
	pageDimensions: {
		pageWidth: function() {
			return sb_windowTools.pageSize.viewportWidth > sb_windowTools.windowSize.windowWidth ?
				sb_windowTools.pageSize.viewportWidth :
				sb_windowTools.windowSize.windowWidth;
		},
		pageHeight: function() {
			return sb_windowTools.pageSize.viewportHeight > sb_windowTools.windowSize.windowHeight ?
				sb_windowTools.pageSize.viewportHeight :
				sb_windowTools.windowSize.windowHeight;
		},
		windowWidth: function() {
			return sb_windowTools.windowSize.windowWidth;
		},
		windowHeight: function() {
			return sb_windowTools.windowSize.windowHeight;
		},
		horizontalOffset: function() {
			return sb_windowTools.scrollOffset.horizontalOffset;
		},
		verticalOffset: function() {
			return sb_windowTools.scrollOffset.verticalOffset;
		}
	}
};
```

As you can see this object has several functions that go through all of our object checks and dimension calculations then provides an object with 5 simple properties that have every dimension we need for any kind of absolute placement.

Perhaps this code is more complex that is actually necessary, but I like to make my scripts very portable. I can drop this in anywhere and be able to get exactly what I need out of it.

### Using the code

I have created a simple `centerElementOnScreen` function to demonstrate how all this works.

 * The first the you need to do before using any of the dimensions data is to get that data (or update it). You can load all of the dimensions data at once by calling the `updateDimensions` method.
 * Once you have called that method all of the information is loaded and made available through the `pageDimensions` methods. You call these methods directly to retrieve the information. So if you want to know how far the viewer has scrolled down the page you call `sb_windowTools.pageDimensions.verticalOffset()`. I know it’s kind of long, but I like descriptive names. Do not forget the parentheses, since I need to perform some logic on the `pageHeight` and `pageWidth` properties I had to make all of them functions.

Here is an example that will center a test element on the screen when the window loads:

```javascript
window.onload = function() {
	// center the test element on the screen
	sb_windowTools.centerElementOnScreen(document.getElementById('test'));
}
```

### Handling browser scrolling and resizing

Ideally, you will only need to compute these dimensions once, when you build whatever element you are trying to build. However you may need to handle the browser scrolling or resizing after you have done whatever work you needed to do.

The simplest solution is to call the function again and update your interface whenever the `window.onscroll` or `window.onresize` events are fired. I’ve tried to make this function as efficient as possible for a stand-alone function but it will have to recalculate information that surely hasn’t changed. Of course there is a more efficient way, but it requires some additional code.

What we can do is add just the needed code to the window events. Here is an example that will update just the scroll offset and reposition the element whenever the user scrolls the page.

```javascript
window.onscroll = function() {
	// update the scroll information
	sb_windowTools.updateScrollOffset();
	// update the vertical position of the element
	var element = document.getElementById('test');
	element.style.top = (
		(sb_windowTools.pageDimensions.verticalOffset() + sb_windowTools.pageDimensions.windowHeight() / 2) -
		(sb_windowTools.scrollBarPadding + element.offsetHeight / 2)
	) + 'px';
};
```

Now, when the user scrolls it will only update the needed information. This is really unnecessary, simply calling the `centerElementOnScreen` method in the onscroll event is perfectly acceptable. The execution time is so minimal that you really shouldn’t even bother. But if you are incredibly obsessive about optimizing your JavaScript code then this is the way to do it.

### Working example

Here is a working example with this code.

<script type="text/javascript" src="/misc/sb_windowTools.js"></script>
<div style="height:300px;padding:10px;border:1px solid #eee;">
<div id="test" style="padding:100px;background-color:#ccc;border:1px solid #000;width:300px;">
<input type="button" onclick="centerMe()" value="Center Me!" /> <input type="button" onclick="cancelMe()" value="Cancel" />

<small>Click “Center Me!” and scroll. Click “Cancel” to reset.</small>
</div>
</div>

Please note that this is not the best way to keep an element in a fixed position on the page. It’s just a good example of the code.

### Conclusion

There, I’ve successfully made a simple task complex and difficult to understand. I hope at least some of this information will be useful to someone out there! If you have any questions or comments please leave them in the form below and I will respond asap.
