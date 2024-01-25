---
title: 'JavaScript regex trick: Parse a query string into an object'
description: 'A super-simple JavaScript trick to translate a query string into a JavaScript object that can easily be used and understood.'
slug: 2010/03/javascript-regex-trick-parse-a-query-string-into-an-object
pubDate: 2010-03-03T18:42:02Z
image:
  src: '../../assets/thumbnails/js-qs-code.png'
  alt: 'Screenshot of a JavaScript code snippet'
categories:
- Web Development
tags:
- JavaScript
- Tips and Tricks
---

Have you ever needed to get query string values using JavaScript? This task is usually a painful split, split, split, iterate, `indexOf` hack that is really slow and terribly ugly to look at. It also tends to pile up lines of code really fast.

Here is a really sweet way to parse the query string into a JavaScript object with two lines of code using regular expressions to populate an object. I discovered this trick a few years ago and filed it away in my code snippets folder.

<!-- more -->

### The Code

The JavaScript code itself uses the `replace()` method with a regular expression to target the name/value pairs in the URI string that you are working with. The replace value is actually a function which will be executed for each pair. This little function simply pushes the name/value pair into the `queryString` object.

```javascript
var queryString = {};
anchor.href.replace(
	new RegExp("([^?=&]+)(=([^&]*))?", "g"),
	function($0, $1, $2, $3) { queryString[$1] = $3; }
);
```

Isn’t it beautiful? In this example `anchor` is some anchor tag on a page that I have already defined with a `document.getElementById`. However it works just as well with `window.location.href`.

### Using it

Using this simple trick you can access query string parameters by saying `queryString['name']`. Let’s say that your URI looks like this:

`http://your.domain/product.aspx?category=4&product_id=2140&query=lcd+tv`

Want that product ID? Simple, `queryString['product_id']` will return `'2140'`. Nice and simple.

If the query string parameter that you are searching for does not exist then it will return `undefined` without throwing an error.

### Full example

Copy and paste this into your Firebug console and run it to see it in action:

```javascript
var uri = 'http://your.domain/product.aspx?category=4&product_id=2140&query=lcd+tv';
var queryString = {};
uri.replace(
	new RegExp("([^?=&]+)(=([^&]*))?", "g"),
	function($0, $1, $2, $3) { queryString[$1] = $3; }
);
console.log('ID: ' + queryString['product_id']);     // ID: 2140
console.log('Name: ' + queryString['product_name']); // Name: undefined
console.log('Category: ' + queryString['category']); // Category: 4
```
