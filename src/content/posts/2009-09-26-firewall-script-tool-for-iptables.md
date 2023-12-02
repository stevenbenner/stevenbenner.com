---
title: 'Firewall script tool for iptables'
description: 'If you’re just getting started with iptables and you want a good strong rule set to use or learn from then check out the Easy Firewall Generator for IPTables. This is a great little tool that will give you a shell script with a very nice rule set.'
slug: 2009/09/firewall-script-tool-for-iptables
pubDate: 2009-09-26T08:34:12Z
modDate: 2010-03-03T19:04:06Z
transitory: true
image:
  src: '../../assets/thumbnails/iptables2.png'
  alt: 'iptables rules script'
categories:
- System Administration
tags:
- Linux
- Networking
- Security
- Tips and Tricks
- Tools
- Ubuntu
---

If you run a public linux server of any kind then you should have a firewall running. Hopefully you already know that. I prefer [iptables](http://www.netfilter.org/) because it is so powerful, however the iptables language is a little less than intuitive.

If you’re just getting started with iptables and you want a good strong rule set to use or learn from then check out the [Easy Firewall Generator for IPTables](http://easyfwgen.morizot.net/gen/). This is a great little tool that will give you a shell script with a very nice rule set.

Just fill out the form and save the script to your server. Run the shell script and you have a great firewall with good logging. Though don’t auto-run the script on bootup until you are absolutely sure that you have the rules perfect, iptables can and will happily lock you out of your own server for good.

<!-- more -->
