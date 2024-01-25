---
title: 'AddThis: friendly widget and brilliant viral tracking scheme'
description: 'A minor expose on how the AddThis social bookmarking widget is now being used as a data mining bug for Clearspring, an online media company. I also provide some technical recommendations for how to reduce it’s tracking capabilities to help protect the privacy of your website’s users.'
slug: 2010/02/addthis-friendly-widget-and-brilliant-viral-tracking-scheme
pubDate: 2010-02-14T08:15:15Z
transitory: true
image:
  src: '../../assets/thumbnails/addthis-logo.png'
  alt: 'AddThis logo'
categories:
- Web Development
tags:
- Analytics
- JavaScript
- Privacy
- Rants
---

I was once a huge fan of the *AddThis* social bookmarking widget, it’s a simple device for adding the social network buttons that everyone expects to see on every page on the internet (now-a-days). It has excellent browser support and is very simple to implement, modify and configure. As far as social bookmarking widgets go, it is probably the best.

However, in the latter half of 2008 [AddThis was acquired by Clearspring](http://www.reuters.com/article/idUSTRE48T1Q820080930), an online media company. They were able to see the value in having a glorified tracking bug on hundreds of thousands of sites across the internet. It’s grown to such an extent that [Clearspring now sees what half of the internet is doing](http://www.readwriteweb.com/archives/clearspring_now_sees_what_half_of_the_internet_is.php).

I’m no tinfoil hat paranoid, but I was a bit surprised at the scale and power of this system. Personally I congratulate them on their wild success. It was a brilliant idea and has become an internet phenomenon. However, I have no interest in giving Clearspring information on my visitors (for free).

So lets reduce it’s tracking ability with a couple lines of JavaScript.

<!-- more -->

### Neutering the AddThis widget (a little)

You can greatly reduce their tracking abilities by adding two simple configuration options to the AddThis settings.

```javascript
var addthis_config = {
	data_use_cookies: false,
	data_use_flash: false
}
```

The first statement, `data_use_cookies` is fairly obvious, it turns off the AddThis cookies. However many web users who are concerned about their privacy have already taken to limiting or disabling cookies altogether. There is however an ingenious workaround that few people even know exists, the [Local Shared Object](https://en.wikipedia.org/wiki/Local_Shared_Object) (<abbr>LSO</abbr>) feature in *Flash*.

### Local Shared Objects

LSOs are basically cookies, but their bigger and better in every way. Flash LSOs do not expire and can hold much more data. Most importantly, they are almost never deleted by users. The only way to control them is through the [Global Storage Settings](http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager03.html) control via Adobe’s Flash configuration on their web site, or with the [BetterPrivacy](https://addons.mozilla.org/en-US/firefox/addon/6623) Firefox add on.

If you’re in the business of analytics and tracking, LSOs are where it’s at. This is why we are setting `data_use_flash` to `false`. The widget itself has no reason to use flash, the only reason it is in there is because Clearspring wants to use LSOs to augment their tracking.

If you’re a Firefox user you can pick up the BetterPrivacy add on and get in-browser control of your LSOs. Like I said, I’m not a paranoid, but I do believe in protecting online privacy.

### Does this really change anything?

No, not really. I don’t know the internals of their analytics system, but if they have any know-how whatsoever they can grab 95% of their analytics information from the tracking data provided by the widget JavaScript and logs. Removing the cookie tracking does however make it more difficult for their cross-domain tracking system to aggregate and collate user interests.

### Conclusion

If you are concerned about your privacy online them only use [Mozilla Firefox](http://www.mozilla.com/firefox/) and pick up the [BetterPrivacy](https://addons.mozilla.org/en-US/firefox/addon/6623) and [CookieMoster](https://addons.mozilla.org/en-US/firefox/addon/4703) add-ons (you need both). They will stop the simple cookie/LSO based tracking systems.

If you are concerned about the privacy of the visitors on your web site then do not use AddThis bookmarking widget. But if you really can’t come up with an alternative at least be sure to add the JavaScript code I posted above with your AddThis widget. [ShareThis](http://sharethis.com/) is an alternative, but they are hoping to cash in the same way.

In the end, you and your site’s visitors have little to no privacy when it comes to browsing habits. Google knows that you’re looking at my site right now. This isn’t something to be afraid of, but be aware that this is the way it works. As a web site administrator the best you can do is to not use content or tools provided by metrics or advertising companies. If you can you should replace AddThis with some simple icons and links, and if you have the resources, replace Google Analytics with [Piwik](http://piwik.org/). But that is too far even for me.
