---
title: 'Optional parameters and named parameters in C# 4.0'
description: 'C# 4.0 is adding various quality of life improvements. In this article I introduce you to two of my favorite new additions: optional parameters and named parameters. An explanation of what they do, how to use them, and examples of why they are excellent language features.'
slug: 2010/02/optional-parameters-and-named-parameters-in-c-4-0
pubDate: 2010-02-24T22:12:19Z
modDate: 2010-03-03T19:04:29Z
image:
  src: '../../assets/thumbnails/csharp.png'
  alt: 'C#'
categories:
- Desktop Development
- Web Development
tags:
- .NET
- C#
- Tips and Tricks
---

One little quirk of *C#*, which has pretty much become a defining characteristic of the language, is the default parameters system, or lack thereof.

If you want to have a default set of arguments for a function or constructor then you have to create several overloaded versions of the function for each possible set of parameters that you want to be able to accept.

This will no longer be the case in C# 4.0 with the addition of *optional parameters* and *named parameters* features. This is one little change I am really looking forward to in a big way.

<!-- more -->

### Traditional overloads

The use of good old fashioned overload functions isn’t going to be completely replaced by the new optional parameters system, but you will almost never need them again.

Here is an example of how we currently do default parameters:

```csharp
static string test(int foo)
{
	return test(foo, "The value is {0}", false);
}

static string test(bool bar)
{
	return test(1, "The value is {0}", bar);
}

static string test(int foo, string blah)
{
	return test(foo, blah, false);
}

static string test(string blah, bool bar)
{
	return test(1, blah, bar);
}

static string test(int foo, string blah, bool bar)
{
	if (bar)
	{
		return String.Format(blah, foo);
	}
	else
	{
		return String.Format(blah, foo + 5);
	}
}
```

This is a lot of code for very little work. In fact, this doesn’t even cover all of the options, but I shortened it for this article. However this is how us C# programmers have been doing it forever.

### C# 4.0 default parameters

With the new default parameters feature in C# 4.0 you can set the default value for any argument. The syntax for this is identical to JavaScript and couldn’t be simpler, `arg = default`.

Using this you can refactor the above functions into one short and readable function:

```csharp
static string test(int foo = 1, string blah = "The value is {0}", bool bar = false)
{
	if (bar)
	{
		return String.Format(blah, foo);
	}
	else
	{
		return String.Format(blah, foo + 5);
	}
}
```

I absolutely adore this syntax. Like I said it is identical to JavaScript and is so much leaner and meaner. Improved readability always means improved maintainability.

### C# 4.0 named parameters

This is all well and great, but the default parameters feature alone cannot replace the overload system. What if you want to skip an argument in the parameters list?

Named parameters to the rescue! This feature allows to you specify names and values when calling a function. Again, the syntax couldn’t be simpler, `name: value`.

This means that we can call that function with any parameters we want, in any order. For example:

```csharp
test(foo: 3, bar: true);
```

Parameter order does not matter when using this syntax, the parameter name is all the information needed to attach the value. You can even mix named parameters with regular arguments.

```csharp
test(15, bar: true, blah: "{0} is the value");
```

However, when mixing named parameters with regular parameters the named parameters must come after all of the regular parameters, and the regular parameters must be in the correct order.

### Conclusion

This tiny, almost insignificant change will probably deprecate *hundreds* of lines of code in your average C# project. It will make functions and constructors much more readable and will make whole projects much more maintainable. It will reduce unneeded code and generally make your cs files shorter.

This single, tiny change is my single favorite upgrade to C# in 4.0.
