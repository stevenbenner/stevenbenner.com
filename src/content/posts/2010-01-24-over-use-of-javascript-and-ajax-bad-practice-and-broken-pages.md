---
title: 'Excessive JavaScript and AJAX: bad practice & broken pages'
description: 'An ever increasing number people believe that everything on a web page should be built with JavaScript. Many take this idea so far that they believe it’s okay to say that they do not support users without JavaScript. I disagree. In this article I present my thoughts on the trend of over-reliance on JavaScript.'
slug: 2010/01/over-use-of-javascript-and-ajax-bad-practice-and-broken-pages
pubDate: 2010-01-24T22:07:29Z
modDate: 2011-04-27T22:44:06Z
transitory: true
image:
  src: '../../assets/thumbnails/ajax-logo.png'
  alt: 'AJAX logo'
categories:
- Web Development
tags:
- Accessibility
- AJAX
- JavaScript
- jQuery
- Rants
- SEO
---

I’ve written tens of thousands of lines of JavaScript code and I love the language. I have used it on almost every site that I’ve worked on in the last 10 years. It makes web pages and web applications so much better in every way. That is, if it’s used correctly, in moderation.

However, for the last few years it feels like I’ve had to spend more time explaining why we should not use JavaScript than I do actually writing scripts. This is a trend that I’ve noticed more and more as the web matures. An ever increasing number people believe that JavaScript is the solution to everything. Many take this idea so far that they believe it’s okay to say that we don’t support users without JavaScript.

<!-- more -->

Often it’s because someone wants to use words like *“AJAX”*, *“JSON”*, *“dynamic”*, and *“Web 2.0”* in marking materials. Sometimes it’s because people believe that scripts are somehow more maintainable than the code-behind. The rest of the time it’s just pure laziness.

**These are the golden rules of JavaScript:**

 * Pages should display all of the real content and media with JavaScript disabled.
 * All front facing pages should functionally work 100% with JavaScript disabled.
 * Pages should look (mostly) the same with JavaScript disabled.
 * Do not use JavaScript when server-side coding can accomplish the same thing.

If you take these rules to heart then you will understand the real point of JavaScript, to enhance pages and user experience.

### Thoughts on AJAX and JSON

[<abbr title="Asynchronous JavaScript and XML">AJAX</abbr>](https://en.wikipedia.org/wiki/Ajax_%28programming%29) and [<abbr title="JavaScript Object Notation">JSON</abbr>](https://en.wikipedia.org/wiki/JSON) are very powerful tools in the web developers’ arsenal, they give you the power to send and pull data from servers without forcing a page load. However, it is very easy to take it too far and break the golden rules. These technologies are best used on top of existing (working) web applications that only require a 1-step postback.

Every web developer knows of AJAX, it is synonymous with dynamic pages. AJAX is used to send standard `GET` or `POST` requests to web servers through the browser and pull XML data back. This offers almost limitless options for a web developer. You can literally build and run an entire web application on top of one HTML page.

The lesser known of the pair, JSON is a form serialized data for JavaScript. It allows you to pull data from the server to a front-end page. The limit of JSON is that you can only pull it through the browser with a `GET` request, so there are limits on the amount and type of data you can send to the server. The idea is basically the same as AJAX, without the XML processing or cross-domain issues.

<figure>

![Screenshot of the Twitter home page](../../assets/postimages/twitter-screenshot.png)

</figure>

For a good example of AJAX and JSON taken too far, just take a look at Twitter, specifically their search. Every time you see a # symbol in the URL you are seeing a hack to support dynamic data and the back button. I understand why they did it, to save page loads, and because it is easier on the servers to publish XML/JSON than it is to craft and return an HTML layout. But they could have accomplished the same thing by publishing the XML data to the browser with an [<abbr title="Extensible Stylesheet Language Transformations">XSLT</abbr>](https://en.wikipedia.org/wiki/XSLT) stylesheet for look and feel.

The [World of Warcraft](http://www.worldofwarcraft.com/) web site uses the XML/XSLT technique and it works great. Since Twitter’s whole service, API, and back-end is based on publishing XML data this technique would have been the perfect solution for them. All of the fancy dynamic loading only reduces the usability of the search feature.

Remember Twitter doesn’t have to worry about <abbr title="Search Engine Optimization">SEO</abbr>, accessibility or backwards compatibility. You do. Don’t use AJAX or JSON for anything but gloss and finish on a functioning base web site. Relying on dynamic calls for widgets and decorations are fine, but don’t require it for any real content.

I will add that I think all of the AJAX in Gmail is fine. Why? Because Gmail is a *web application*, behind a login screen. The context is different than a page on a front-facing web site that you might find through a search engine. Web users understand that they are entering something different than a static page when they log in to their Gmail accounts.

### Thoughts on libraries

There are countless JavaScript libraries available for anyone to use. Some are better than others, some are truly terrible. When asked, I always recommend [jQuery](http://jquery.com/), along with the caveat that you should not use any library unless you are going to use a significant amount of the functionality that library makes available.

Forcing users to download 81kB of script just so you can `$('a#next').click()` is a complete waste. You can accomplish the same thing just as easily with the native [<abbr title="Document Object Model">DOM</abbr>](https://en.wikipedia.org/wiki/Document_Object_Model) functions and skip the extra bandwidth, server load, and page load times.

However, if you know that you’re going to be doing a lot of advanced scripting on a site, then please, use a library, preferably jQuery. Having one browser-cached file with all of the fundamental work done can be a lifesaver. jQuery is very powerful and can save you lots of time and headaches on a big project.

### Conclusion

Do use JavaScript, love it, and even punish users for not having it. But, don’t rely on it for making your consumer-facing web sites work. Only rely on JavaScript for garnish. Though anything behind a login screen is fair game, go crazy. When you do use JavaScript make sure to use unobtrusive techniques and follow graceful degradation ideals. Your work will be more professional, more portable, more accessible and even have better SEO.
