---
title: 'Setting up an Ubuntu LAMP server. Part 2: Apache'
description: 'Part 2 of my LAMP server configuration guide. In this installment I provide a walk-through for the process of setting up Apache HTTP server. As well as some education about the various configuration options.'
slug: 2012/02/setting-up-an-ubuntu-lamp-server-part-2-apache
pubDate: 2012-03-01T03:34:18Z
modDate: 2012-07-11T19:21:51Z
transitory: true
image:
  src: '../../assets/thumbnails/apache-logo.png'
  alt: 'Apache HTTP server logo'
categories:
- System Administration
tags:
- Apache
- How-To
- LAMP
- Linux
- Security
- Tips and Tricks
- Ubuntu
---

This is part two in my Ubuntu LAMP server series. In this article I will guide you through the process of installing and setting up the [Apache HTTP Server](http://httpd.apache.org/).

If you are setting up a web server then you are probably best off running Apache. There are other web servers that will serve your needs and maybe even serve them faster but Apache is the default, for good reason.

There are arguments to be made for the merits of nginx and lighthttpd, but I get everything I need out of Apache and enjoy using it. I really cannot say enough good things about Apache, I love it and it is my web server of choice. I recommend it as the starting point for all web servers.

<!-- more -->

### About Apache

The internet runs on Apache, simple as that. There are other notable web servers that have been gaining popularity over the years, and they do offer some performance benefits, however Apache is the benchmark by which they are all judged.

In my opinion you should run Apache unless you have a specific reason to use one of the other servers.

#### Why use Apache

Apache is the stalwart web server, it has been the de facto web server software since I first started playing with the internet. But age alone does no great software make (though it sure can help). So here are the reasons to use Apache.

 * **Unfathomable age.** In software terms, Apache is older than time. Calling this software “time-tested” is like saying that Egypt has “been around for a while”. The Apache server has been running the internet so long that it has seen, been the victim of and subsequently patched just about every web server issue ever known.
 * **Stable.** As a system administrator this should be your number one concern. Would you rather serve your content 10ms faster or know that your server is extensively tested and nearly impossible to break (if it’s set up properly)?
 * **Default web server.** Basically every mainstream web application that you can download (blogs, forums, CMSs, etc.) was built using Apache and comes specially setup to run on Apache (most notably .htaccess files).
 * **Exceptional (community) documentation.** The official Apache documentation is very good, but is difficult for most people to process. However, the wealth of tutorials, walk-throughs, guides, FAQs and forums is unrivaled. If you have a question about Apache it has been asked at least 1000 times, and been answered at least 2000 times.
 * **Extensibility.** The Apache mods system is great. You can enable or disable features very easily and they perform very well.
 * **Well maintained.** Since most of the internet runs on Apache any issue that comes up is a very big deal. Problems are found and patched very quickly.
 * **Performance.** Although you may have heard otherwise, Apache is fast. If properly tuned it is as fast as any other server on the market.

#### Why not to use Apache

There are times when Apache is not the best choice.

 * **Performance.** Yes, Apache can be as fast as any other server on the market, but it takes a little more tweaking to get it there. The default configuration seems designed for heavy hitting dedicated machines, and will bring most <abbr title="Virtual Private Server">VPS</abbr> instances to their knees if they get significant traffic. If you screw up the configuration at all then your sites will go down the first time you get linked on Reddit.
 * **Memory footprint.** Apache tends to be more memory heavy than the newer servers. This is what usually causes issues on VPSs.

#### The other popular web servers

Of course this wouldn’t be an Apache web server article if I didn’t at least point out the other options.

 * **[nginx](http://nginx.org/)** – Probably the best alternative web server. It is very fast, memory efficient and configuration is very intuitive. Speed is the top priority here.
 * **[lighthttpd](http://www.lighttpd.net/)** – I don’t have much first-hand experience with this one, but I can tell you that it is very efficient and scales well. Configuration can get just as complicated, if not more-so than Apache.

### Apache Multi-Processing Modules

Before I dive in to the install and configuration guide I do need to touch on one of the more advanced considerations, MPMs and their affects. This is the most advanced option with Apache, you do not need to know this to get a server up and serving hundreds of thousands of pageviews per day. You probably do need to know this to serve millions of pageviews a day.

You have a choice of several [Multi-Processing Modules](http://httpd.apache.org/docs/2.0/mpm.html) *(MPMs)* for your web server. These are the internals of how Apache works and have some very important considerations.

 * **[MPM Prefork](http://httpd.apache.org/docs/2.0/mod/prefork.html)**

	This is a **non-threaded** system that launches a separate Apache process for each connection. This is the setup that *just always works*, there are no special considerations for your web applications and no restrictions on modules. You will be running mod_php5 for this MPM and each process will have its own instance of PHP loaded. As a result MPMs based prefork takes a bit more memory than the threaded MPMs based on worker.

	Configuration is based on limiting the total number of server processes spawned and their lifespan.

	Prefork is the default apache2 package on Ubuntu.

 * **[MPM Worker](http://httpd.apache.org/docs/2.0/mod/worker.html)**

	Worker is a system that uses separate **threaded** Apache processes. In this system you will be running [FastCGI](https://en.wikipedia.org/wiki/FastCGI) with [mod_fastcgi](http://www.fastcgi.com/mod_fastcgi/docs/mod_fastcgi.html) or possibly [mod_fcgid](http://httpd.apache.org/mod_fcgid/) to execute PHP. This is significantly more memory efficient than the prefork system, but the overall performance difference is debatable. The speed at which the server works may or may not be improved, but FastCGI is, in general, faster for PHP scripts.

	However, if you want <abbr title="Alternative PHP Cache">APC</abbr> (which you do) you should know that there are [caching issues with APC and and mod_fcgid](https://bugs.php.net/bug.php?id=57825) that we cannot work around right now, so the best option is to use the slightly older and slower mod_fastcgi with [php-fpm](http://php-fpm.org/). In addition to the threading and APC issue with fcgid, some older PHP code will not play well with a FastCGI environment (e.g. older MediaWiki versions). Modern PHP code should not have any issues in this environment but it may be something you need to consider.

	Moving forward I suspect that MPM worker with php-fpm will probably become the default setup because of its speed and memory efficiency.

	Configuration is based on limiting the number of threads and their lifespan.

 * **[MPM ITK](http://mpm-itk.sesse.net/)**

	This is an MPM designed for web hosts that want to be able to isolate virtual hosts with user accounts. It is based on prefork and runs the same way.

	Don’t use this one unless you know you need to. I only mention it because there is the apache2-mpm-itk package available to you.

 * **[MPM Event](http://httpd.apache.org/docs/2.2/mod/event.html)**

	**Do not use this one**, Apache calls it experimental for a reason. Event is a modified version of worker that has special reserved processes to handle listening and such.

	In the future this may be awesome-sauce, but it is not ready for production.

### Installing Apache

The basic Apache install really could not be simpler on Ubuntu. Just execute the following command:

```shell
sudo aptitude install apache2
```

Alright, you now have Apache 2 installed. That’s it.

### Configuring Apache

Now this part is a bit more complicated than the install. We need to configure some basic global variables and set your MPM limits to values that make sense for your server.

First off lets set the basics, open up your apache2.conf file which is located in /etc/apache2.

```shell
sudo nano /etc/apache2/apache2.conf
```

Now lets do some configuration. I’m not going to list every option you can configure, just the ones you need to change. You should take the time to read over [all of the configuration directives](http://httpd.apache.org/docs/2.0/mod/core.html) in Apache.

#### Basic configuration

 * **`ServerName`** – Used in server signatures and some server generated links. If you are only going to run one web site on this server then set this to that sites URL (e.g. `www.example.com`). If you are going to run more than one site then set this to the server’s IP address (e.g. `12.34.567.890`).
 * **`Timeout`** – How long someone can hang a connection open before requesting a page. I set this to `30` seconds, which I feel is generous. The default config value of `300` is outrageous.
 * **`KeepAliveTimeout`** – How long to hold connections open for followup requests. My recommendation is to set this short, I would recommend `2` to `5` seconds.
 * **`ServerTokens`** – What the server should tell the world about itself in the response header. The default setting is to send the full version information with PHP and mod versions. You might as well print out a list of every hack your system is vulnerable to in the headers. Set this to `Prod`.
 * **`ServerSignature`** – What kind of signature to show on server generated pages. I personally set this to `Off`.
 * **`TraceEnable`** – Whether or not to allow TRACE requests. The default is to allow them, but there is absolutely no reason to so you should set this to `Off`.

#### MPM Prefork configuration

The default values for MPM Prefork are fine, if you’re running a dedicated server with 4 gigabytes of memory. For us normal people we need to tune these way down or the server will light on fire (or start thrashing like crazy) when you get a significant amount of traffic.

 * **`StartServers`** – The number of server processes to spawn when Apache starts up. The server will almost instantly change the number of server processes so it’s irrelevant, but for the sake of consistency set this to your `MinSpareServers` value.
 * **`MinSpareServers`** – Minimum number of active server processes to keep up waiting to handle new requests. This has nothing to do with how many requests the server can accept, it’s about reducing the delay users would see because of the start-up time needed for new processes. This should be a relatively small number, I set it to `10`.
 * **`MaxSpareServers`** – Maximum number of waiting server processes. Apache will slowly kill these off when the server isn’t seeing much traffic. The point here is to not have a lot of pointless processes hanging around holding memory. Generally speaking this should be double your `MinSpareServers`.
 * **`MaxClients`** – This is the important one, how many servers can we have up and actively talking to users. This does not mean how many connections the server will accept, it’s how many processes it can have running concurrently doing the work of processing requests, taking uploads, executing PHP, and serving data out to users. When the server reaches the `MaxClients` number further incoming requests will be queued and processed in order. The default in the config is `150`, you want to turn this way down. For a server with about 1GB of RAM I would recommend setting this in the range of `15` to `50`, depending on if you are running other services on the system (MySQL = set this low), how memory efficient your web apps are and how fast your server serves up requests.
 * **`MaxRequestsPerChild`** – This is a safeguard to prevent server processes from leaking memory and never returning it. The default config value is zero, which means that child processes never die. You should set this to a large number, say `1000` to `5000`.

##### Example config for a 1GB VPS with well tuned MySQL:

```
<IfModule mpm_prefork_module>
	StartServers            5
	MinSpareServers         5
	MaxSpareServers        10
	MaxClients             25
	MaxRequestsPerChild  1000
</IfModule>
```

#### Save your config and reload Apache

Once you’ve got all of your basic global settings where you want them then exit nano by hitting Ctrl+X and Y to save.

Now reload the Apache server:

```shell
sudo /etc/init.d/apache2 reload
```

Your web server is now running with your new settings.

### Virtual hosts

Name based virtual hosts are how we do multiple web sites on one server. You have the DNS records for the sites pointing at your web servers IP address and virtual hosts for each domain set up on the web server. Setting up a virtual host in Apache is very simple indeed.

You do this by creating a virtual host config file, these will be located in /etc/apache2/sites-available.

#### Default virtual host

If you hit the IP of the server in your browser (no host name passed) you will get the *default virtual host*. This default web site is the one that will be shown when Apache cannot match the requested host to any named virtual host.

The first virtual host that does not specify the `ServerName` in its configuration will be the default virtual host. Apache comes with a default virtual host (called “default”) already set up and running in the sites-available folder, but if you set the `ServerName` on default and add another virtual host that starts with a number or a letter combination that would sort it before the word “default” then that will become the default virtual host.

If you need to add such a domain then I recommend changing the file name of “default” to something like “000-default”. This is how you do it:

```shell
cd /etc/apache2/sites-available
sudo a2dissite default
sudo mv default 000-default
sudo a2ensite 000-default
```

#### Adding a new virtual host

Alright, let’s create a new virtual host. Start by creating the directories for your new site. You can put the directories anywhere you want, but the convention for Ubuntu is that web sites belong in /var/www, and I recommend following that convention. Let’s create a folder for the domain that contains an *htdocs* folder for the web site and a *logs* folder for the logs.

```shell
sudo mkdir /var/www/yourdomain.com
sudo mkdir /var/www/yourdomain.com/htdocs
sudo mkdir /var/www/yourdomain.com/logs
```

Now, create a new file in the sites-available directory:

```shell
sudo nano /etc/apache2/sites-available/yourdomain.com
```

And paste in this virtual host config:

```
<VirtualHost *>

	ServerName yourdomain.name
	ServerAlias www.yourdomain.name
	ServerAdmin webmaster@yourdomain.com

	DocumentRoot /var/www/yourdomain.com/htdocs

	<Directory />
		Options FollowSymLinks
		AllowOverride All
	</Directory>

	<Directory /var/www/yourdomain.com/htdocs>
		Options FollowSymLinks
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>

	CustomLog /var/www/yourdomain.com/logs/access.log combined
	ErrorLog /var/www/yourdomain.com/logs/error.log
	LogLevel warn

</VirtualHost>
```

Exit nano (Ctrl+X to exit, and Y to save). Now you just enable the site:

```shell
sudo a2ensite yourdomain.com
```

And reload Apache:

```shell
sudo /etc/init.d/apache2 reload
```

That’s it. You can do all kinds of crazy configuration in the virtual host, but that template is enough to get your site up and running. If your DNS is set up right you should be able to hit your domain in a browser and see whatever is in /var/www/yourdomain.com.

### Web optimizations

Now is the time to do some tuning for the client side of your web server. If you’ve ever used the YSlow or PageSpeed add-ons for Firefox (must have for web developers) you’ve probably seen them complaining about sites that don’t gzip, or that use ETags. Well let’s make sure your sites are not guilty of those sins.

These changes are made by adding these configuration values to the bottom of your config file (it can go anywhere in the file, I just prefer to keep these kinds of customizations all in one place)

To edit your apache2.conf again just enter this command in the console:

```shell
sudo nano /etc/apache2/apache2.conf
```

After you’ve made your changes you exit nano (Ctrl+X to exit, Y to save), and reload Apache with this command:

```shell
sudo /etc/init.d/apache2 reload
```

#### gzip static files

This is the single best server side optimization you can do, it costs you almost nothing in terms of performance and greatly reduces the over-the-wire footprint of files, and thus response time.

First, enable mod_deflate:

```shell
sudo a2enmod deflate
```

And add the following to your apache2.conf:

```
# mod_deflate - add gzip compression
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css application/x-javascript
```

You are now serving static text, HTML, XML, CSS and JS files gzipped.

#### ETags

File ETags are used to compare a cached file against the servers version of that file and determine if the client needs to get the latest full version of that file. However they are generally not recommended because they are usually unique to the machine that sent the file so you can’t use them if you want to use multiple machines to serve front-end content.

That probably won’t be a problem for you, but since I am a whore for YSlow scores, and [YSlow recommends against them](http://developer.yahoo.com/performance/rules.html#etags), I always disable ETags.

This is the code to disable ETags:

```
FileETag None
```

#### Far-future cache expiration dates

To get the most out of client-side caching it is recommended that you set the cache expiration into the distant future for all static files. This will ask clients to hold onto your static files for a long time so that they do not have to regularly re-download them, wasting time and bandwidth.

However, **I do not recommend this for most people** because you are forced to implement versioning on all of your resource files (e.g. stylesheet_v1.2.css). If you want to modify a CSS file you have to make a new copy of that file and give it a file name and/or path different from the original because anyone that has that file cached will not receive any of the changes.

If you are willing to deal with this hassle then this is a nice boost to the effectiveness of caching.

Enable mod_expires:

```shell
sudo a2enmod expires
```

And add the code to set up far-future cache expiration dates on static files:

```
# Add far-future expiration dates
ExpiresActive on

<FilesMatch "\.(ico|pdf|flv|jpg|jpeg|png|gif|js|css|swf)$">
	ExpiresDefault "access plus 10 years"
</FilesMatch>
```

#### Further reading

I recommend you get both the YSlow and Page Speed add-ons and test your sites with them. These really are invaluable tools for improving your web site performance.

Also, I highly recommend taking the time to read through the official [Yahoo performance best practices](http://developer.yahoo.com/performance/rules.html) and [Google performance best practices](http://code.google.com/speed/page-speed/docs/rules_intro.html) documents. They are filled with excellent tips for both the server and the web site.

### Other useful mods

This article covers the basics of getting Apache up and running. From here on you can keep it simple or get as complicated as your heard desires. There are at least a few other mods that you should probably be aware of to help you on your journey:

 * **rewrite** – The Apache URL rewriter, industry standard, much beloved and keeping the internet working. This will allow you to do URL rewriting, which is a huge article unto itself. Google to learn about Apache URL rewriting.
 * **auth_basic and auth_digest** – These are the authentication modules that are used to require a username and password to access a file or directory on the server. Very useful, I personally like to protect admin folders (e.g. wp-admin for WordPress) with authentication, just as an extra layer of inconvenience to would-be hackers. Always use digest, don’t bother with basic.
 * **status** – Useful for seeing what your web server is doing at any particular moment. This will give you the Apache status page that you might have seen before. Also, required for some monitoring tools (i.e. munin). Remember to require authentication on that page as well or anyone can see what sites/files you are sending and what IPs are accessing them.

### Conclusion

Apache is an awesome web server for any and every purpose, and is very easy to get up and running. It takes some more tuning to get it right, but once you’ve got it all setup and running smoothly it is almost impossible to bring down (from normal usage).

If you have any questions or notice that I forgot to cover something important then please leave a comment below and I’ll get back to you as soon as I can.
