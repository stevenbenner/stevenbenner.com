---
title: 'External templates for the DataView control: Microsoft Ajax Library 4.0'
description: 'The new DataView control in the latest beta of the ASP.NET AJAX Library version 4.0 has a template engine built into it. Unfortunately, those templates must be embedded in the page markup. Here is a workaround technique that I came up with for importing an external template file into a page.'
slug: 2010/01/external-templates-for-the-dataview-control-microsoft-ajax-library-4-0
pubDate: 2010-01-30T04:59:20Z
modDate: 2010-03-07T20:57:19Z
image:
  src: '../../assets/thumbnails/aspdotnet-ajax.png'
  alt: 'Microsoft ASP.NET AJAX logo'
categories:
- Web Development
tags:
- .NET
- AJAX
- How-To
- JavaScript
---

One of the best things about *templates* is how portable they are. You can build a template for a particular piece of presentation and then use that template everywhere you need it. In fact you can have several templates to choose from, giving you themes and different ways of displaying the same data.

This is a very powerful and very *maintainable* technique. Portable template files are a great example of the *Don’t Repeat Yourself* (DRY) principal and are a good idea for any template that will see reuse.

The new *DataView* control in the latest beta of the [Microsoft Ajax Library](http://www.asp.net/ajaxlibrary/) version 4.0 (aka *the ASP.NET AJAX Library*) has a fine template engine built into it. Unfortunately, those templates must be embedded in the page markup. If it’s your project then you can simply use an ascx User Control, or a `ContentPlaceHolder` or an `Html.RenderPartial`, but what if you need to be able to use the template on a static file, or a clients site, or even in another framework? You can’t have portable template files that you can just call anywhere. Well, you can, but you have to use a workaround technique.

This is one technique that I came up with for importing a template file into a page. This lets me have one (or a selection of) template files that I can use everywhere for a portable JavaScript widget. It has no dependencies other than the Microsoft Ajax Library.

<!-- more -->

You can save your template as an html or xml file in your project and then, using an AJAX connection, download the template and insert it into the page. Once the template has been inserted into the page you can create the DataView control and generate the widget.

First off create the JavaScript file, in this case `MyWidget.js`:

```javascript
var displayElement;

function WidgetInit() {
	displayElement = $get('MyWidget'); // div that we will insert the template into

	// create a new web request and pull Template.html
	var wRequest = new Sys.Net.WebRequest();
	wRequest.set_url('/Template.html');
	wRequest.set_httpVerb("GET");
	wRequest.set_userContext("user's context");
	wRequest.add_completed(WidgetWebRequestCompleted);
	wRequest.invoke();
}

function WidgetWebRequestCompleted(executor, eventArgs) {
	if (executor.get_responseAvailable()) {
		// insert the markup from Template.html into the display div
		displayElement.innerHTML += executor.get_responseData();
		// create the DataView using the inserted template
		$create(Sys.UI.DataView, { data: MyWidgetData }, null, null, $get("MyWidgetTemplate"));
	}
}
```

Next we’ll create `Template.html`, which contains our template:

```html
<table id="MyWidgetTemplate" class="sys-template" border="1">
	<tr>
		<td>{{Name}}</td>
		<td>{{WebSite}}</td>
	</tr>
</table>
```

And finally bring it all together in the page:

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>Microsoft Ajax DataView External Template Demo</title>
		<style type="text/css">
			/* make the template invisible until the work is done */
			.sys-template {display:none}
		</style>
		<script src="scripts/MicrosoftAjax.js" type="text/javascript"></script>
		<script src="scripts/MicrosoftAjaxTemplates.js" type="text/javascript"></script>
		<script src="scripts/MyWidget.js" type="text/javascript"></script>
		<script type="text/javascript">
			// this should come from a javascript include tag, but for the
			// sake of example, im embedding it here for you
			var MyWidgetData = [
				{ Name: "Steven Benner", WebSite: "https://stevenbenner.com/" },
				{ Name: "Bill Gates", WebSite: "http://www.gatesfoundation.org/" },
				{ Name: "Stephen Hawking", WebSite: "http://www.hawking.org.uk/" }
			];

			function pageLoad() {
				WidgetInit();
			}
		</script>
	</head>

	<body>

		<h1>Microsoft Ajax DataView External Template Demo</h1>

		<!--
			The MyWidget div is the target where the template will be
			inserted, and the widget content generated.
		-->
		<div id="MyWidget"></div>

	</body>

</html>
```

This is kind of a hacky solution, but it works. Often, when I want to use templates, I want to use external templates. Simple flat files that I can change, cache and version. After all, half the point of templates is having the ability to have a *selection* of different templates.
