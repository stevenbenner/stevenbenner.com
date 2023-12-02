---
title: 'Graceful degradation theory, IE and CSS3'
description: 'CSS3 offers a wide array of very important and useful features. There are so many new features that you will have to do some serious reading to get caught up. In this article I tell you about my favorite new features and offer some advice on using them in the wild.'
slug: 2010/01/graceful-degradation-theory-ie-and-css3
pubDate: 2010-01-21T23:13:00Z
modDate: 2010-12-05T02:00:36Z
transitory: true
image:
  src: '../../assets/thumbnails/css3.png'
  alt: 'CSS3'
categories:
- Web Development
tags:
- CSS
- Internet Explorer
---

As most web developers know, CSS level 3 is [in the works](http://www.w3.org/Style/CSS/current-work), and has been for quite some time now. Unfortunately it is still just a working draft and cannot be adopted in full by the standards compliant web browsers. But that doesn’t mean we can’t start benefiting from the technology today.

CSS3 offers a wide array of very important and useful features. All of which will give web developers increased productivity, better maintainability and better design practices. There are so many new features that you will have to do some serious reading to get caught up.

But I can tell you about the ones that I’ve fallen in love with and offer up some theory and advice on using them in the wild world of the web.

<!-- more -->

### The big ones

To me personally, these are the greatest pieces of technology offered in the current CSS3 spec:

 * **[border-radius](http://www.w3.org/TR/css3-background/#the-border-radius)**

	Rounded corners! Without the images, browser hacks, script hacks, or 5 layers of non-semantic nested divs.

 * **[opacity](http://www.w3.org/TR/css3-color/#transparency)**

	Set transparency on all of your favorite block elements. Now you can do those nifty overlays without custom images and png hacks.

 * **[Attribute selectors](http://www.w3.org/TR/css3-selectors/#attribute-selectors)**

	How many times have you had to type `input.text` or `input.button` and add a bunch of pointless classes because you didn’t want your form styling to effect your button styling? Now you can say `input[type^=text]`!

 * **[Text columns](http://www.w3.org/TR/css3-multicol/)**

	The one thing that CSS2.1 could never do right, real text columns with equal height. This won’t work for page structure, but it will be an excellent new resource for text layout.

These new CSS features will be a huge time-saver and encourage better development practices. But there is a catch.

### Theory of graceful degradation

Now here’s the big wrench is your machine. None of these, not a single one works in Internet Explorer, any version. But wait! Before you hit the back button, bare with me for a moment.

This doesn’t mean that we can’t use them today. Firefox, Chrome, Safari, etc, all have support for these features already using a form of custom CSS declarations (e.g. `-moz-border-radius` and `-webkit-border-radius`). It just means that Internet Explorer users (bless their hearts) won’t get the same exact look.

Is this really such a big problem? The content of your pages should be your focus. If you’ve truly been creating web pages with graceful degradation then you have already been designing using features that you assume will not exist in all browsers and formats.

I have been using the border-radius feature for about a year now. I still use GUI caps or corner overlays when I need round corners as part of the basic look of the user interface. But, whenever I want to place round corners on content divs I just add the moz/webkit CSS. Internet Explorer users will see a square box, but it doesn’t affect the experience. I sacrifice an irrelevant and unnecessary visual effect on IE and in return I get easy to maintain CSS with more semantic markup.

People who are stuck on Internet Explorer can still use the site just as well as the Firefox/Chrome crowd, it just doesn’t look exactly as smooth. And that is perfectly acceptable.

The idea of graceful degradation is that you build your site for the worst environments and design it for the best.
