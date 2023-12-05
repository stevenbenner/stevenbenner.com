---
title: 'Custom link click tracking using Omniture'
description: 'This article is step-by-step how-to for building a custom link tracking for Omniture with JavaScript. In the hopes that I can save some other JavaScript developer out there the headaches and frustration that is usually associated with learning advanced Omniture implementations.'
slug: 2010/03/custom-link-click-tracking-using-omniture
pubDate: 2010-03-07T20:55:28Z
modDate: 2010-04-14T06:00:31Z
transitory: true
image:
  src: '../../assets/thumbnails/omniture-logo.gif'
  alt: 'Omniture logo'
categories:
- Web Development
tags:
- Analytics
- How-To
- JavaScript
---

Omniture is the de facto standard tracking and analytics system that most online retailers use. It has a suite of reporting metrics and allows for custom reporting variables. It is primarily designed for online stores to track usage, conversions and sales.

Admittedly, I am not that big a fan of Omniture. Their *SiteCatalyst* reporting application is slower than Google Analytics and not as flexible as it could be. My biggest gripe is their tracking JavaScript code, it’s just plain terrible. It’s slow, obfuscated (really? why do this?), bloated, impossible to debug and not built using modern practices. Oh, and they’re also insanely expensive if you want to get at all fancy.

This article is simply a straight how-to for building a custom link tracking JavaScript in the hopes that I can save some other JavaScript developer out there the headaches and tears usually associated with learning advanced Omniture implementations.

<!-- more -->

### Omniture basics

The Omniture JavaScript does all of its work through the `s` object. This object has many different methods and properties that are all ingeniously designed to confuse and torment would-be implementers.

For custom tracking metrics you will be using *prop codes*, which are called *“Custom Insights”* in the SiteCatalyst reporting software. You associate a specific prop code to a specific piece of data. So you may associate `s.prop1` to be the category of a product and `s.prop2` to be the name of the product.

The way we track is by loading up prop variables with strings then telling the Omniture code to run. This is done by calling `s.t()` for a pageview track or `s.tl()` for a link click track.

### How to track a click action with custom prop data

The code to track an action is actually quite simple, loading prop values and calling the tracking method. Here is what a tracking script looks like. This example is the basic custom click tracking code that you would expect to see in an *onclick* event attached to an anchor tag.

```javascript
s.linkTrackVars = 'prop1,prop2';
s.linkTrackEvents = 'None';
s.prop1 = 'Televisions';
s.prop2 = 'Samsung - LN40B530 - 40" LCD TV - 1080p (FullHD)';
s.tl(this, 'o');
```

Now, this is fairly self-explanatory, but I’ll break this down line for line so you know exactly what’s happening and what these statement mean.

 * **s.linkTrackVars** declares which prop codes you will be using in this event. This property is a comma-separated list of each prop code that you want tracked.
 * **s.linkTrackEvents** are the “events” that an action may represent. Usually you will use events like “purchase” or “save” but you can put just about anything you want in here. It’s just a different way of looking at the same information. I typically set it to none and use custom insights for reports.
 * **s.prop1** and **s.prop2** are the custom metrics that will be attached to this click event. In this case prop1 is the product category and prop2 is the product name.
 * **s.tl(this, 'o')** calls the tracking action. The `tl()` method (a.k.a. the *trackLinks method*) requires two parameters, this anchor object to be tracked (should always be `this`) and the type of link we are tracking. There are three types of basic links that is method understands: o is the “Other/General” link type, d is a “File Download” link, and e which is an “Exit Link”. Anything that isn’t a download or exit link should be given the “o” tag.

There you have it, not incredibly complex, but not obviously simple either. There are a bunch of other properties that you can attach to a trackLinks event, but this is what 99% of them look like.

### Building a script to attach link tracking events automatically

There are two standard ways to attach these custom link tracking events to the anchors that you want to track: *the stupid method*, and *the smart method*.

 * **The stupid method** is the most common. This involves adding an onclick tag to every anchor and filling it with the appropriate code.
	* Pros: Stupid, simple, always works
	* Cons: Stupid, unmaintainable, ugly, increases markup, adds non-semantic markup
 * **The smart method** is to build a single script that will attach the code to every link you want to track automatically on page load.
	* Pros: Smart, not-stupid, simple, maintainable
	* Cons: Links don’t get the tracking events attached until the whole page has finished loading.

For this rest of this article I will assume that you want to use *the smart method*. Basically, we will build a script that will look at every single anchor tag in the <abbr title="Document Object Model">DOM</abbr> and attach the click tracking events to any links matching whatever criteria you choose. This script will automatically run when the page loads.

### Defining the criteria and search pattern

First off, you must be able to identify the links that you want to track. I have used two different systems for this: Searching href tags and adding rel tags.

Searching href tags is generally the best option. This means matching the link href and attaching the event based on that data. However I have found situations where I didn’t want to track every link that had the string “products.aspx” in it, so I chose to add rel tags to those links that I did want to track. This way I could just search for links that had rel=”product” in them.

The technique is still basically the same, we will gather all of the anchors in the document into an array, then iterate through the array, attaching the appropriate events and data to those anchor which meet our criteria for each type of page.

### The basic script structure

No matter what you choose as your search criteria and trackable data you will need a script that has at least the following features:

 * Iterates through all anchors on a page
 * Allows you to attach tracking events *without overriding* any existing events
 * Automatically runs as soon as the page loads
 * Highly *optimized* for minimum execution time
 * Cannot throw an error that will break the page
 * *Unobtrusive design* that doesn’t have any dependencies (other than Omniture)
 * Namespaced in *object literal notation* so that it can never have any conflicts

#### The basic JavaScript object that I use for this

```javascript
// Omniture click tracking
// https://stevenbenner.com/2010/03/custom-link-click-tracking-using-omniture/

if(!sb_trackLinks) { var sb_trackLinks = new Object(); };

sb_trackLinks = {
	// initialize the click-tracking system and attach events
	init: function() {
		// verify that we are running in a modern browser, if not give up silently
		if (!document.getElementsByTagName) return false;

		// iterate through all of the links in the document
		var anchors = document.getElementsByTagName('a');
		for (var i=anchors.length-1; i>=0; i--) {

			// SEARCH STATEMENTS AND TRACKING VARIABLE BUILDING GOES HERE

		};
	},

	// tracking function
	track: function(obj, propCodes, linkType = 'o') {
		s = s_gi(s_account);
		// reset tracking properties
		s.linkTrackVars = '';
		s.linkTrackEvents = 'None';
		// iterate through each property in propCodes
		for (code in propCodes) {
			s.linkTrackVars += code + ','; // build the CSV list
			s = propCodes;     // attach the prop code
		}
		// track it
		s.tl(obj, linkType);
	},

	// non-breaking/non-overriding/cross-browser event attachment
	addEvent: function(obj, evType, fn, useCapture) {
		if (obj.addEventListener) {
			obj.addEventListener(evType, fn, useCapture);
			return true;
		} else if (obj.attachEvent) {
			var r = obj.attachEvent('on' + evType, fn);
			return r;
		} else {
			obj['on' + evType] = fn;
		};
	}
};

// auto-init on load
sb_trackLinks.addEvent(window, 'load', sb_trackLinks.init);
```

This is the basic outline of my JavaScript click tracking object. It has three methods and automatically runs itself in the window.onload event.

I’ve put a lot of thought into optimizing this script. For instance, notice that I reverse iterate through the anchors array. This technique has been proven to be faster because the array length is only calculated once when the for statement begins. If you do the `while i<array.length` style then the length is calculated once for every iteration in the loop.

When you build any kind of tracking or analytics JavaScript your highest priority should be to shave every nanosecond from it’s operations. It is acceptable to sacrifice readability for performance here. After all, as a web developer your primary job should be to improve *user experience*, tracking scripts are a necessity but do not benefit users in any way, so you do your best to reduce their impact on user experience.

### The sb_trackLinks methods

There are three methods in the sb_trackLinks object:

 * **init()**

	The init() method is where the startup, initialization and event attachment will occur. We still need to build the search criteria, tracking variables and event attachment code before this will do anything.

 * **track(obj, propCodes, linkType)**

	The track() method is the code that will be attached to the onclick events for the anchors that we want to track. It requires two parameters and will accept a third.

	* **obj:** The first parameter is the anchor object that we will be tracking, in the context of our for statement in the `init()` method this will always be `anchors[i]`.
	* **propCodes:** The second parameter is an object with the prop codes that we want to use. This should be a standard JavaScript *object* with the conventions as the `s.propXX` codes. So if you want to track prop1 you should set `propCodes['prop1']` to the value that you want and pass it through to the `track()` method.
	* **linkType:** The third parameter is the link type that will be passed to s.tl() and is optional. It will default to `'o'`. As I said earlier, it will accept o, d and e as valid values.

	You may have to modify this function if your Omniture code has been customized.

 * **addEvent(obj, evType, fn, useCapture)**

	The addEvent() method is the standard addEvent that you see everywhere on the internet.

### Crafting the search and tracking variables

Now that we have a basic structure that we can use, all that we need to build is the anchor search statements, tracking variable and event attachments.

This needs to be custom built for your specific needs. The application, URL structure and tracking needs are all critical parts of this equation. If you are using [friendly URLs](/2010/02/friendly-urls-in-an-asp-net-app/) and need to parse data from them then you will may have to deconstruct the URI to grab the specific data that you want to track in prop codes. If you need data from somewhere else on the page you will have to figure out out to grab it. Et cetera.

I’ll provide you with an example based on our previous examples. In this case we are tracking clicks in an online store application. We are using standard query string parameters in our URLs and do not need any other special data.

This is what our `for` statement will look like for this site:

```javascript
for (var i=anchors.length-1; i>=0; i--) {
	// parse the query string into an object
	var queryString = {};
	anchors[i].href.replace(
		new RegExp("([^?=&]+)(=([^&]*))?", "g"),
		function($0, $1, $2, $3) { queryString[$1] = $3; }
	);

	// conditionals to match link href targets
	if (anchors[i].href == 'http://your.domain/' || anchors[i].href.indexOf('home.aspx') > -1) {
		// home page
		sb_trackLinks.addEvent(anchors[i], 'click', (function() {
				return function() {
					try {
						sb_trackLinks.track(
							this,
							{
								'prop1': 'home'
							}
						);
					} catch(e) {}
					return true;
				};
			})()
		);
	} else if (anchors[i].href.indexOf('category.aspx') > -1) {
		// category pages
		sb_trackLinks.addEvent(anchors[i], 'click', (function(catId) {
				return function() {
					try {
						sb_trackLinks.track(
							this,
							{
								'prop1': 'category',
								'prop2': catId
							}
						);
					} catch(e) {}
					return true;
				};
			})(queryString['category_id'])
		);
	} else if (anchors[i].href.indexOf('product.aspx') > -1) {
		// product pages
		sb_trackLinks.addEvent(anchors[i], 'click', (function(catId, productId, productName) {
				return function() {
					try {
						sb_trackLinks.track(
							this,
							{
								'prop1': 'product',
								'prop2': catId,
								'prop3': productId,
								'prop4': productName
							}
						);
					} catch(e) {}
					return true;
				};
			})(queryString['category_id'], queryString['product_id'], queryString['product_name'])
		);
	};
};
```

This is a bit technical, and uses some advanced JavaScript techniques. However, it should be fairly understandable if you know your way around JavaScript.

Since we need to grab query string values for most of our tracked pages I start off by [parsing the query string into an object](/2010/03/javascript-regex-trick-parse-a-query-string-into-an-object/).

I then proceed down a list of `if` statements that try to match a specific page. Inside each `if` statement I attach an onclick event to the current anchor. That event passes our current data down through the JavaScript scope via a `(function(v){})(data)` statement. Inside that event I call the `track()` method with the data and return true so that the browser follows the link once the code as been executed.

This can get very long indeed if you have a lot of different types of pages in your web application that need click tracking. As always, order your if statements by commonality, putting the most commonly matched statements first. The script engine will have to fail every if check to get to the last statement. This minor optimization may save you a millisecond or two.

It is very important that you **wrap all of the code inside the event in a `try{}catch(e){}`** just in case something somewhere breaks. If you do not do this then the links on your site will stop working if anything goes wrong. There is nothing quite as asinine as links not working because the tracking script is broken.

### Putting it all together

Now that we’ve built the search and attach code all we have to do is insert it into our base script. The result looks like this:

```javascript
// Omniture click tracking
// https://stevenbenner.com/2010/03/custom-link-click-tracking-using-omniture/

if(!sb_trackLinks) { var sb_trackLinks = new Object(); };

sb_trackLinks = {
	// initialize the click-tracking system and attach events
	init: function() {
		// verify that we are running in a modern browser, if not give up silently
		if (!document.getElementsByTagName) return false;

		// iterate through all of the links in the document
		var anchors = document.getElementsByTagName('a');
		for (var i=anchors.length-1; i>=0; i--) {
			// parse the query string into an object
			var queryString = {};
			anchors[i].href.replace(
				new RegExp("([^?=&]+)(=([^&]*))?", "g"),
				function($0, $1, $2, $3) { queryString[$1] = $3; }
			);

			// conditionals to match link href targets
			if (anchors[i].href == 'http://your.domain/' || anchors[i].href.indexOf('home.aspx') > -1) {
				// home page
				sb_trackLinks.addEvent(anchors[i], 'click', (function() {
						return function() {
							try {
								sb_trackLinks.track(
									this,
									{
										'prop1': 'home'
									}
								);
							} catch(e) {}
							return true;
						};
					})()
				);
			} else if (anchors[i].href.indexOf('category.aspx') > -1) {
				// category pages
				sb_trackLinks.addEvent(anchors[i], 'click', (function(catId) {
						return function() {
							try {
								sb_trackLinks.track(
									this,
									{
										'prop1': 'category',
										'prop2': catId
									}
								);
							} catch(e) {}
							return true;
						};
					})(queryString['category_id'])
				);
			} else if (anchors[i].href.indexOf('product.aspx') > -1) {
				// product pages
				sb_trackLinks.addEvent(anchors[i], 'click', (function(catId, productId, productName) {
						return function() {
							try {
								sb_trackLinks.track(
									this,
									{
										'prop1': 'product',
										'prop2': catId,
										'prop3': productId,
										'prop4': productName
									}
								);
							} catch(e) {}
							return true;
						};
					})(queryString['category_id'], queryString['product_id'], queryString['product_name'])
				);
			};
		};
	},

	// tracking function
	track: function(obj, propCodes, linkType = 'o') {
		s = s_gi(s_account);
		// reset tracking properties
		s.linkTrackVars = '';
		s.linkTrackEvents = 'None';
		// iterate through each property in propCodes
		for (code in propCodes) {
			s.linkTrackVars += code + ','; // build the CSV list
			s = propCodes;     // attach the prop code
		}
		// track it
		s.tl(obj, linkType);
	},

	// non-breaking/non-overriding/cross-browser event attachment
	addEvent: function(obj, evType, fn, useCapture) {
		if (obj.addEventListener) {
			obj.addEventListener(evType, fn, useCapture);
			return true;
		} else if (obj.attachEvent) {
			var r = obj.attachEvent('on' + evType, fn);
			return r;
		} else {
			obj['on' + evType] = fn;
		};
	}
};

// auto-init on load
sb_trackLinks.addEvent(window, 'load', sb_trackLinks.init);
```

Save this code in the s_code.js (or whatever you named it) script for your Omniture-enabled web site and it will start sending click data back to your Omniture account.

### Gotchas

There are some possible problems that may crop up using this system.

 * **Page never stops loading**

	I have seen pages that simply never stop loading because of poor use of AJAX, slow servers, or broken dependencies. The click tracking events will not be attached to links until the loading icon in the browser stops.

 * **Links added after page load**

	If there are any links that are created after the page load event is fired, such as AJAX widgets or dynamic links, then they will not exist when this script is run and therefor will not have any tracking events attached to them.

 * **Omniture conflicts**

	There have been several occasions where I’ve seen people try to use two (or more) instances of Omniture on the same page. If you have to deal with this then you need to modify the `track()` method to use your account name.

 * **500ms link delay**

	The `s.tl()` function has a half-second delay built into it. This is because the tracking data is sent by requesting a 1 pixel web beacon from the Omniture servers and the script needs to give the browser enough time to send the request. Unfortunately, this also adds an annoying delay to every link that you attach tracking code to.

### Advanced tracking (more than just links)

Omniture link tracking can be used for more than just links. You can use the `s.tl()` method to send any data at any time for any reason. Do you want to track when someone puts their mouse over an image, or how long they waited before scrolling, or even what text they selected? You can do all of that, and more if you *really* want to.

If you ask me those fine-grain *viewer eyeball focus* type of reports are not only invasive but genuinely useless. However, I’ve been asked to do even worse invasive and pointless tracking before. If you need to you can send any data you want on any DOM event, or even with timers.

The only thing that you must overcome is that the object you pass to `s.tl()` must be an anchor, or more specifically, *something* with an href attribute. There is nothing about this in the documentation, but it simply doesn’t seem to work unless it has an anchor with an href passed to it. You can get around this by creating an element or simply passing `true`.

This is, however, the subject of a different article.

### Conclusion

As you can see it’s not *that* difficult to implement custom link tracking with Omniture and you can get some very powerful reports without that much work. I still cannot give my glowing stamp of approval for Omniture as a reporting solution, for various reasons, but if you are using it then hopefully this tutorial will save you some time and headaches.

If you have any questions or comments please leave them in the form below and I will do my best to answer them. You can also take a look at the [Custom Link Tracking](http://blogs.omniture.com/2009/03/12/custom-link-tracking-capturing-user-actions/) post in the Omniture blog. It’s a year old, but the author is still responding to questions.
