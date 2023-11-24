---
title: 'PHP needs an IDE and a membership provider'
slug: 2009/09/php-needs-an-ide-and-a-membership-provider
pubDate: 2009-09-06T00:24:17+00:00
modDate: 2010-02-07T19:44:21+00:00
image:
  src: '../../assets/thumbnails/php-logo.png'
  alt: 'PHP logo'
categories:
- Web Development
tags:
- .NET
- LAMP
- PHP
- Rants
---

For the last few years I have spent more time working in the .NET framework than I do PHP. It’s not that I don’t like PHP, quite the opposite, I love PHP. However, it seems most of the work I’ve been seeing is for the .NET Framework. And there is a reason for that, .NET is more powerful in terms of pure control, the Visual Studio IDE is absolutely awesome for working with large solutions, and the .NET library provides so many powerful tools.

PHP has a lot going for it, it is powerful, scale-able, easy to work with, and free. The LAMP (Linux Apache MySQL PHP) solution is the standard on the internet. And for a good reason! It’s cheap, it’s fast, it’s memory efficient, and it is very secure (if run by a capable admin). I prefer to work on LAMP systems because I can lock it down so well with tools that are well tested and maintained, and to top it off Linux hosting is cheap!

But PHP does have some drawbacks. A large PHP project can be a nasty endeavor to catch up on. As a developer I always find it difficult coming into a PHP project and trying to figure out what is where. The conventions are simply the whims of whatever the original developer(s) were used to (sometimes none at all).

Also, the trouble with working on large projects. I know that intelisense and “Go To Definition” have spoiled me horribly, but really, that is what the standard should be. Don’t even think about saying “Aptana”, that is the worst IDE I’ve ever had to use. I’ve never seen such a leaky, slow, and bloated excuse for an IDE before. Of course it doesn’t help that the JRE is so terrible on windows.

There are two things that are woefully missing from PHP right now.

 1. An IDE as awesome as Visual Studio
 2. A membership provider

Why a membership provider? Because I love PHP software, and there are so many great open source software packages out there. But using more than one on a single site is a terrible thing to go through. What if I want a blog, a wiki, and a forum on one site? That means three different logins, not only for myself, but for my users. Sure, I could write custom hacks to get it to use one database, but that means modifying the code in such a way as to make upgrades a nightmare. PHP apps are supposed to be quick and painless to update.

The way I see it, centralized login is a major missing piece in PHP. If there was an official PHP based membership provider, that was maintained and well-integrated with PHP, then many of the open source projects would start using it.

It should be this simple:

 * Install the PHP Membership module
 * Configure it to use whatever database you’re running
 * Install whatever PHP software packages you want
 * Configure the software packages with the login zone ID
 * Logins and sessions work across all of the different apps on the site!

Imagine how great that would be!

**Update:** [I found An IDE for PHP that doesn’t suck](/2010/01/an-ide-for-php-that-doesnt-suck/).
