---
title: 'Friendly URLs in an ASP.NET app'
description: 'A comparison of the various options for implementing friendly URLs in your ASP.NET web application. With some of my thoughts about the options and some code demonstrating and example implementation.'
slug: 2010/02/friendly-urls-in-an-asp-net-app
pubDate: 2010-02-05T03:04:13Z
transitory: true
image:
  src: '../../assets/thumbnails/aspdotnet-logo.gif'
  alt: 'Microsoft ASP.NET logo'
categories:
- Web Development
tags:
- .NET
- How-To
- SEO
---

Friendly URLs are a great way to improve <abbr title="Search Engine Optimization">SEO</abbr>, promote linking and generally make your web application look more professional. If you have already hopped on to the <abbr title="Model–View–Controller">MVC</abbr> bandwagon then you don’t need to worry about it, friendly URLs are one of the great many benefits to using ASP.NET MVC. However, if you are still using web forms you will have to go through a couple extra steps to get the same effect.

Just in case you don’t know what a friendly URL is, *“friendly URLs”* (aka *“Pretty URLs”*, *“Beautiful URLs”*, *“URL Rewriting”*, *“URL Mapping”*, *“SEO URLs”*, etc.) I am talking about pages or resources that are identified by keywords in a pseudo-directory structure. For Example, you have a web application with a search page. In a standard web forms application your URI will probably look something like this:

`http://your.address/Search.aspx?query=friendly`

In a friendly URL structure, your URI would look something like this:

`http://your.address/search/friendly`

This is a much leaner and cleaner looking link. Really better in every way, though if you are still using ASP.NET web forms you will have to go through some trouble to make your links look like that. As well as having to deal with maintaining the rules and code to support it. It may very well not be worth the trouble.

If your web application is consumer facing and relies on search engines for traffic then you should probably implement friendly URLs in some form for your app.

<!-- more -->

Using friendly URLs is by no means required. They have been proven to increase relevancy in search engines because the keywords in the URL adds weight to the result for any matching keywords. But this really is the only benefit that can be used to justify the time and maintenance it takes to deal with using friendly URL strings. If your web application is behind a login screen, or doesn’t need to be ranked in search engines then friendly URLs are probably not worth the trouble.

### Options

You have a lots of options for implementing friendly URLs in your ASP.NET application. There are dozens of URL rewriting solutions for .NET out there, these are just the few that I have had real experience using.

#### Use MVC – its grrrrrrreat!

By very definition, ASP.NET MVC gives you great URLs without extra effort or maintenance issues. The MVC system uses the ASP.NET routing engine, a very nice solution which is integrated into the ASP.NET application life cycle. Since it’s integrated into .NET itself it is very fast and requires zero maintenance.

There are so many other reasons to use MVC that I wouldn’t even try to go over them in this post. Suffice it to say that I haven’t built a new web forms application since MVC 1.0 was officially released. As far as I’m concerned, this is the way ASP.NET should work.

If however, you must use web forms then you still have two other good solutions.

#### IIS 7 URL Rewrite Module

If you are running <abbr title="Microsoft Internet Information Services">IIS</abbr> 7 and have enough access on your server to add and manage IIS modules then the official IIS 7 URL Rewrite module is your best choice. It is fast, since it is directly integrated with IIS and it is official, so it’s fully supported.

* [Official URL Rewrite Module Page](http://learn.iis.net/page.aspx/734/url-rewrite-module/)
* [URL Rewrite Module Forum](http://forums.iis.net/1152.aspx)

Implementing pretty URLs with the IIS7 URL Rewrite Module is pretty straight forward. You have to install the module on the server then configure the site, either via the administration panel, or in the web.config.

#### Managed Fusion Rewrite library

This is another good solution. The Rewrite module from Managed Fusion is a <abbr title="Dynamic-Link Library">DLL</abbr> that you add to your project. It runs as an HttpModule that you configure in the web.config. It will pull your rewrite rules from a separate file that you specify in the web.config or you can set your rule in the web.config itself. This module uses standard Apache mod_rewrite syntax and commands .

It is a proprietary library, but has a nice open license so you can use it for personal or commercial purposes. It is reasonably well maintained and I have personally used it in very high traffic environments.

 * [Official Managed Fusion URL Rewriter Page](http://www.managedfusion.com/products/url-rewriter/)
 * [Managed Fusion Rewriter at Codeplex](http://urlrewriter.codeplex.com/)
 * [Apache mod_rewrite documentation](http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html) (syntax reference)

Implementing the Managed Fusion rewriter is actually very simple, especially if you are already familiar with Apache’s mod_rewrite syntax. You just need to reference the rewriter DLL in your project and build the rewriter rules. It’s all in one solution with no external dependencies so it’s easy to deploy and manage. You don’t have to mess with any IIS configuration.

#### Roll your own

If you have special needs, or are feeling bored, then sure, you can roll your own solution. I don’t recommend it. You don’t want to have to deal with every possible URL in code, nor do you want to build and maintain something hundreds of other people are doing already (maybe you can reinvent the wheel), it will just be a maintenance nightmare.

### Implementation

Setting up a web forms application to implement a URL rewriting system is fairly straight forward, but will take some time and some serious thought.

#### Install rewriter

First off set up whatever rewriter solution you have chosen and verify that it is working. I gave you all of the links you’ll need to get them working already.

#### Define URL formats

Now you need to figure out exactly what format you will follow for URLs. This planning step is unique to every application so I can’t give you much advice, except to say that you should focus on adding the important keywords. Do not pack the URL with too many keywords, you will get punished for keyword stuffing. Keep it simple, like `/search/QUERY` or `/user/NAME`.

In this example I will define the search URLs as:

`/search/SEARCH_QUERY`

`/search/SEARCH_QUERY/PAGE_NUMBER`

#### Build rewriter RegEx

The next step is to write the actual string statements that will match your new friendly URL structure and extract the data that you need to pass the page. Basically all rewriter systems, including the IIS 7 URL Rewrite Module and the Managed Fusion Rewriter, use *[Regular Expressions](https://en.wikipedia.org/wiki/Regular_expression)* to do the string matching and evaluation. There is an art to writing good regex statements. If you haven’t learned regex yet it’s never too late to start, you will find them useful throughout your career.

In this case I’ll be using the Managed Fusion Rewriter because I am so used to doing this kind of thing in apache. The MF Rewriter uses the same functions and syntax as Apache’s mod_rewrite. For a good reference check out the [Apache mod_rewrite documentation](http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html).

Here is an example rewriter file for our little search app running Managed Fusion.

```perl
# Initialize the rewriter
RewriteEngine On
RewriteBase /

# Search rules
########################

# Basic search rule
# matches "/search/some_search_query
RewriteRule ^/search/(\w+)$          /Search.aspx?query=$1          [NC,L]

# Search pagination rule
# matches "/search/some_search_query/2" (i.e. page 2)
RewriteRule ^/search/(\w+)/(\d+)     /Search.aspx?query=$1&page=$2  [NC,L]
```

Lets take a closer look at the rule on line 10:

 * **`RewriteRule`** begins the statement telling the processor that this is a one-line rule. This statement has 3 arguments.
 * **`^/search/(\w+)$`** is the regex that we are trying to match in the friendly URL. Breaking it down the first character is a carrot `^` which means “begins with”. It is followed by the string `/search/` which is a literal string match. Next is `(\w+)`. `\w` is the “word” character, it means any alpha-numeric or basic symbol character. The `+` means “one or more”. That whole statement is wrapped in parentheses, which means “save this value so I can access it later”. The last character is the `$` symbol, which means “ends with”. Putting it all together this regular expression reads *“Begins with /search/, followed by, and ending with, one or more word characters. Save the word characters into $1”*.
 * **`/search.aspx?query=$1`** is the rewritten URL that we will evaluate the friendly URL into. This is the *real URL* that will be executed. The `$1` means the first parentheses item from the first statement. They are in left-to-right order and can be nested as deep as you want.
 * **`[NC,L]`** are the rule statements. In this case I am using `NC` which means “Not Case-sensitive” and `L` which means “Last”. So case has no effect on the match, and when it does match it stops processing the rewriter rules. If you don’t have the `L` statement then the rewriter engine will keep testing every rule that follows it, wasting processing power and possibly matching a rule further down that you didn’t want it to use.

#### Create a class to build your new URLs.

Now that you know what your URLs should look like and have gotten them working, you need need to be able to link to them anywhere in the application. My solution for this is to build a class in the code-behind to handle creating the URLs. No matter what we do we will have to maintain URLs and support these changes in two places, the rewriter rules, and the UrlBuilder class. But this is better (and more maintainable) than custom crafting URLs every time you want to link them.

Here is an example class for our search application:

```csharp
public class BuildUrl
{
	public string Search(string searchQuery)
	{
		return Search(searchQuery, 1);
	}

	public string Search(string searchQuery, int pageNumber)
	{
		if (pageNumber == 1)
		{
			return "/search/" + HttpUtility.UrlEncode(searchQuery);
		}
		else
		{
			return "/search/" + HttpUtility.UrlEncode(searchQuery) + "/" + pageNumber.ToString();
		}
	}
}
```

Now you can use this one central class throughout your project whenever you need to create a link. For example if you want to create a search link for “cars” all you have to do is say:

```html
<a href="<%= BuildUrl.Search("cars") %>">Search for cars</a>
```

You will have to build a function for every type of link, but at least it’s easy to maintain.

### Migration

If your web app is already running and is indexed by search engines or linked to by other sites then you will need to setup redirects for every page that you will be moving to a friendly URL. If you don’t then the pages will just 404 or error out. This means that any links to your pages will be broken and the page rank that they’ve earned will be dropped.

So it is indeed very important to properly redirect all old URLs to the new ones, forever. By properly, I mean a HTTP 301 redirect. Status code 301 means “Moved Permanently”, this will tell search engines to update the URL, and browsers will cache the updated URL.

The most simple solution is to add a code block at the top of the page that tests for an old URL, then builds and redirects to a new URL.

Here is a little sample for what our search page redirect would look like:

```csharp
string NewUrl = BuildUrl.Search(Request.QueryString["query"]);

if (Request.RawUrl.IndexOf("/search.aspx", StringComparison.OrdinalIgnoreCase) > -1 ||
	Request.RawUrl.IndexOf(NewUrl, StringComparison.OrdinalIgnoreCase) == -1 )
{
	Response.Status = "301 Moved Permanently";
	Response.AddHeader("Location", NewUrl);
	Response.End();
}
```

Pretty simple right? This needs to be custom made for each aspx page to match the new URL format, but it is a simple block of code.

### Conclusion

It’s a bit of extra work and requires some thought to set up URL beautification, but if your web app depends on people finding it through search engines then it’s probably worth the effort. Think very carefully about the URL structure you use. Once you deploy it to the internet it is very difficult to undo. If you expect people to link to you then you have to support every URL that has ever worked indefinitely.

Once you have it all setup it should keep working just as indefinitely. When you add a new page you will have to add some new rules and a new function to the `UrlBuilder` class but that is fairly easy. Just make sure you get your URL structure right, the first time.

Though, if you are still planning your next app and know you want pretty URLs, now it the time to take a good hard look at ASP.NET MVC and all of the wonderful tools and processes it brings to the table. I have fallen in love with MVC and will probably never make another web forms app. I will of course continue to support the ones that I have.

ScottGu has an old but probably [better post than mine](http://weblogs.asp.net/scottgu/archive/2007/02/26/tip-trick-url-rewriting-with-asp-net.aspx) on his blog. If you’re thinking about implementing rewriting then you should read that one too.
