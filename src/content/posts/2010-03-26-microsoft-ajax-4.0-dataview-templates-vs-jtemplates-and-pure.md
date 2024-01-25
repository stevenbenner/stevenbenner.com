---
title: 'MS Ajax 4.0 DataView Templates vs. jTemplates and PURE'
description: 'My review of the template system added in ASP.NET AJAX version 4.0 with the new DataView control. And a comparison of DataView templates versus the popular jTemplates and PURE templates systems.'
slug: 2010/03/microsoft-ajax-4-0-dataview-templates-vs-jtemplates-and-pure
pubDate: 2010-03-27T03:00:18Z
transitory: true
image:
  src: '../../assets/thumbnails/aspajax-jquery.png'
  alt: 'ASP.NET AJAX and jQuery logos'
categories:
- Web Development
tags:
- .NET
- AJAX
- JavaScript
- jQuery
- Reviews
---

There are many occasions where you’ll want a JavaScript template system to handle the rendering of data. If you’re building any kind of JavaScript widget or user interface that will consume JSON data, then build presentation with that data, you really should consider using a JavaScript template engine. It can save a lot of future headaches and make updates a much easier task.

Up until now there has really been only two good option for doing maintainable presentation templates in JavaScript, *[jTemplates](http://jtemplates.tpython.com/)*, and *[PURE](http://beebole.com/pure/)*. These two template engines allow you to build layout with data.

 * **jTemplates** is a plugin for jQuery, and of course jQuery is by far my favorite JavaScript library, the only one I’ll ever recommend. jTemplates is an abstraction for data and presentation. It even has its own pseudo-language syntax for the template engine.
 * **PURE** (*Pure Unobtrusive Rendering Engine*) is a template engine that works with several JavaScript libraries, including jQuery. This system is designed from the ground up to use valid, unobtrusive techniques to build out it’s templates. PURE templates are normal in-page markup that the JavaScript replaces data in to. A very elegant system indeed.

Now there is a new option coming out along with the new Microsoft .NET Framework release.

 * Version 4.0 of the Microsoft Ajax Library (*aka ASP.NET AJAX*) includes a new client side template system using the **`DataView` control** which is actually quite good. Frankly, it feels like it was inspired by taking the best of jTemplates and PURE but it is enhanced for ASP.NET developers.

I’ve been playing around with this new system and have been pleasantly surprised. Templates are relatively easy to construct, implementation is straight forward, and it works quite well. There are some pros, and some cons when compared to the other template systems.

<!-- more -->

Of course there are actually many other [template plugins](http://plugins.jquery.com/search/node/templates+type%3Aproject_project) for jQuery, however PURE and jTemplates have the best documentation, best syntax and the most recent updates. Almost all of the other template systems have been abandoned or deprecated by their creators.

### Comparison table

Basically all of these template systems have similar features and capabilities. They are all great choices for JavaScript templating, they only really differ in template structure and syntax.

|                    | jTemplates        | PURE                 | MS Ajax `DataView`     |
| :----------------- | :---------------- | :------------------- | :------------------- |
| JSON Data          | Yes               | Yes                  | Yes                  |
| In-page templates  | Yes               | Yes                  | Yes                  |
| External Templates | Yes (as js files) | No (but can be done) | No (but can be done) |
| Valid XHTML        | Yes (hacky)       | Yes                  | Yes                  |
| Fast               | Yes               | Yes                  | Yes                  |
| File Size          | 10kB              | 9kB                  | 50kB                 |

The Microsoft Ajax Library has some nifty features for power users but that is something that I will save for another article. Suffice it to say that any template you care to make can be done in any of these systems.

### Comparison details

#### Supported data

PURE, jTemplates and the `DataView` control can only understand and parse JSON data.

#### In-page templates

When I say “in-page templates” I am talking about markup in the HTML document that gets evaluated as the template. It may be far more convenient for you to build your template as part of the page that will be using it (or it may not). All of these systems support in-page templates, but they have different ways of accomplishing this technique.

 * jTemplates grabs the template by using the jQuery `.html()` method to read the contents of a node. Because jTemplates templates are usually not valid markup the common practice is to store them in a `<script type="text/html">` tag, which is ignored by browsers. This is actually a fairly dirty work-around when you think about it.
 * PURE on the other hand actually uses markup conventions to build templates, so the template itself is simply DOM element on the page. When PURE loads it reads the DOM for the target you specified and attempts to insert data according to their conventions.
 * The Microsoft Ajax `DataView` control also uses templates that do validate as XHTML. So `DataView` templates are just regular in-page elements that are hidden with CSS. `DataView` templates can be a little uglier and a bit more intimidating to look at, but they are valid markup.

Of course since the template for PURE and the `DataView` control are part of the document this also means that crawlers and bad screen readers will see the template as a part of the document.

#### External templates

External templates are separate files that contain the raw template that the script will use. jTemplates will let you store your templates as a JavaScript string. This means that you can simply add another JavaScript file reference to the document and have a separate, cacheable template.

PURE and the `DataView` control on the other hand must be passed a DOM reference to the template element in the document, so if you want to keep your template file external you will need to use a workaround solution, namely AJAX. This workaround will always be somewhat hacky but does work.

I’ve already posted an example of this in the [external templates for the DataView control](/2010/01/external-templates-for-the-dataview-control-microsoft-ajax-library-4-0/) article.

#### Valid XHTML

All of these template engines will read and produce valid markup. As I said, jTemplates has to keep it’s templates inside a `<script>` tag, but this is a valid work around. PURE and `DataView` templates use standard XML structure and are valid in XHTML.

#### Speed

Template engines are by definition are slower than direct rendering. Both jTemplates and `DataView` hold true to this, PURE seems to be a bit faster, but not by much. However they are more then snappy enough for the real world. It is just a fact of life that you have to sacrifice some amount of performance to gain greatly enhanced maintainability.

Personally I find the trade off to almost always be worth it. If you want single-digit millisecond page rendering you shouldn’t be using external data on a web page anyway.

#### File size

*`MicrosoftAjaxTemplates.js`* is notably larger than *`jquery-templates.js`* or *`pure.js`*, five times larger actually. I can understand this because the `DataView` control does a lot more work, but this is something that you may want to factor into a decision on a high traffic web site.

Both the `DataView` control and jTemplates are dependent on their parent libraries, MicrosoftAjax and jQuery, respectively. PURE also requires a base library, but it only requires a CSS selector engine so it supports several libraries, including dojo, DOMAssistant, jQuery, Mootools, prototype.js, Sizzle and Sly.

Another point to factor in is the fact that MicrosoftAjax can be served from Microsoft’s CDN. So you don’t have to worry about the bandwidth costs for these libraries. jQuery is also available from Microsoft’s or Google’s CDN, however the PURE and jTemplates files you will have to host yourself.

### Conclusion

The Microsoft Ajax Library 4.0 has a capable template engine that will be very useful to fans of the Microsoft Ajax Library. This is an excellent new tool in the arsenal of ASP.NET web developers, but it won’t usurp jTemplates’ or PURE’s position as the predominant JavaScript template engines. If you’re building a web app on the Microsoft Ajax Library then you should probably be using the `DataView` control for your templates. Don’t import all of jQuery on top of Microsoft Ajax just for PURE or jTemplates.
