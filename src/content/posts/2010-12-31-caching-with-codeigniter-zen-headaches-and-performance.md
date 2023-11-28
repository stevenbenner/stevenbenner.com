---
title: 'Caching with CodeIgniter: Zen, headaches and performance'
slug: 2010/12/caching-with-codeigniter-zen-headaches-and-performance
pubDate: 2011-01-01T04:47:01Z
modDate: 2012-07-17T15:18:52Z
image:
  src: '../../assets/thumbnails/codeigniter-fade-logo.png'
  alt: 'CodeIgniter logo'
categories:
- Web Development
tags:
- CodeIgniter
- How-To
- PHP
- Tips and Tricks
---

CodeIgniter is already a very fast PHP framework, but that alone might not be fast enough for high traffic web applications. To get to the next level of performance you will need to implement some kind of caching.

Luckily for the CodeIgniter crowd, the framework comes with one of the fastest caching systems possible, *Output Caching*. Short of writing static HTML files or output caching to memory there is no faster way to serve pages.

However, if you have any degree of interactive or dynamic content, total output caching can be painful (if not impossible) to implement. Now there are other options, such as database caching and third party caching libraries, but none of them will be quite as fast as full output caching. So if at all possible that is what you should use.

Let me provide you with an overview of the caching systems available and a few of my tricks.

<!-- more -->

### CodeIgniter Output Caching

CodeIgniter’s [output caching](http://codeigniter.com/user_guide/general/caching.html) system will take the completely rendered output of your views and save them to disk. It’s a very simple idea, and simple is good for performance. When a page is cached there is no need to talk to the database or process anything.

Output caching is actually built directly in to the CodeIgniter life cycle. Every time CodeIgniter starts up it checks to see if the current URL has a cached version on disk. If it finds it then CodeIgniter will completely skip everything and throw the cached version out to the browser.

It’s also incredibly easy to turn on, just call the `cache()` method anywhere in in your controller to output cache the page.

```php
$this->output->cache(MINUTES);
```

#### Overcoming the problems of output caching

There is one major downside to output caching, when a page is cached you *cannot* talk to the database or process anything. The greatest benefit is also the greatest curse. This means that anything the least bit dynamic or user derived cannot be cached this way.

Unfortunately CodeIgniter does not come with partial caching, support for dependencies or even a way to evict items from cache. To me at least, this is the single biggest hole in the awesomeness that is CodeIgniter. Just a little bit more love for the output caching system would make the most scalable PHP framework vastly more scalable.

But we can work around these issues with a little bit of extra thought and design.

**What output caching does parse**

It’s worth mentioning that there are two functions/strings that output caching will parse, even after the file is cached, the [benchmark class’](http://codeigniter.com/user_guide/libraries/benchmark.html) `elapsed_time()` and `memory_usage()` functions. These functions will insert text markers (`{elapsed_time}` and `{memory_usage}`, respectively) that are parsed by CodeIgniter when it sends the output to the browser.

This always makes for some interesting figures so it’s nice to include a HTML comment in your pages with these functions to watch just how fast the output cache is working.

```html
<!--
	Time: <?php echo $this->benchmark->elapsed_time(); ?>
	Mem: <?php echo $this->benchmark->memory_usage(); ?>
-->
```

It’s quite common to see these values go from 0.07 seconds with 3.5MB of memory to 0.006 seconds with 0.75MB of memory. Output caching really does work *that* well!

**The small things**

For most pages on most web applications there are just a few small items that need to by dynamic, such as Login/Logout links, recently viewed items and pretty dates (x days ago). All of these things can be effectively done via JavaScript without losing any significant functionality.

So build a simple API to make the functions available via JSON. For example this is a basic controller that would allow a JavaScript to get the users current status (logged-in, username and group).

```php
class Api extends CI_Controller
{
	public function user_status()
	{
		$logged_in = $this->user_model->logged_in();
		$data = array(
			'isLoggedIn' => $logged_in,
			'userId' => $logged_in ? $this->session->userdata('user_id') : '',
			'userName' => $logged_in ? $this->user_model->get_user()->username : '',
			'userGroup' => $logged_in ? $this->user_model->get_user()->group : ''
		);
		$this->output->set_header('Content-type: application/json');
		$this->output->set_output(json_encode($data));
	}
}
```

Now with that data exposed via an API you can use JavaScript to show the user controls you find at the top of many web applications. Here is an example script using jQuery that would do just that.

```javascript
$.getJSON('/api/user_status', function(data) {
	if (data.isLoggedIn) {
		$('#user-controls').html('Logged in as <b>'+data.userName+'</b> | ' +
			'<a href="/logout">Log Out</a>');
	} else {
		$('#user-controls').html('<a href="/register">Register</a> | ' +
			'<a href="/login">Log In</a>');
	};
});
```

On an average web app this is still at least an order of magnitude faster than not using caching at all since you are only making one query to the database. The page load will finish much faster, then when the page is ready the supplementary content will be loaded.

Now obviously there is a significant down side to this solution; users with JavaScript disabled will not see the login and register links. You could simply show those links by default and overwrite them with script, but for most applications it is a non-issue since many features that require a user to log in will also require that JavaScript is enabled anyway. It’s a judgment call for you to make.

**The big things**

For entire pages that are filled with content that changes regularly you will need a different technique. The best solution that I have found is evicting the cache for a page when you change the data. So when someone posts something you will call a function to clear the cache files for any pages affected.

The preserves the massive performance benefit of keeping output caching enabled but still makes the page completely dynamic.

However, as I said earlier, CodeIgniter does not give you any function to delete cache files so you have to do it yourself. Output cache files are saved in your cache folder (config item) as an MD5 hash of the URI they represent. This is the exact code CodeIgniter uses:

```php
$path = $CI->config->item('cache_path');
$cache_path = ($path == '') ? APPPATH.'cache/' : $path;
[ ........ ]
$uri =	$CI->config->item('base_url').
		$CI->config->item('index_page').
		$CI->uri->uri_string();

$cache_path .= md5($uri);
```

**Note: Actually this is for the latest CodeIgniter 2.0. For 1.7 replace `APPPATH` with `BASEPATH`.**

So you have to search for the cache files you want to purge using that algorithm and `unlink` them. Here is a simple little helper I wrote to do just that.

```php
<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Delete Cache File
 *
 * Evicts the output cache for the targeted page.
 *
 * @author	Steven Benner
 * @link	https://stevenbenner.com/2010/12/caching-with-codeigniter-zen-headaches-and-perfomance/
 * @param	string	$uri_string	Full uri_string() of the target page (e.g. '/blog/comments/123')
 * @return	bool	True if the cache file was removed, false if it was not
 */
if ( ! function_exists('delete_cache'))
{
	function delete_cache($uri_string)
	{
		$CI =& get_instance();
		$path = $CI->config->item('cache_path');
		$cache_path = ($path == '') ? APPPATH.'cache/' : $path;

		$uri = $CI->config->item('base_url').
			$CI->config->item('index_page').
			$uri_string;

		$cache_path .= md5($uri);

		if (file_exists($cache_path))
		{
			return unlink($cache_path);
		}
		else
		{
			return TRUE;
		}
	}
}
```

**You may want to just download my complete [Cache Helper](https://github.com/stevenbenner/codeigniter-cache-helper) from GitHub.** Place cache_helper.php in your helpers directory and you’re good to go. Now you can evict cache files like this:

```php
$this->load->helper('cache');

delete_cache('/blog/comments/123');
```

### CodeIgniter Database Caching

Another caching system that comes with CodeIgniter is the [database caching](http://codeigniter.com/user_guide/database/caching.html) system. This system, as it’s name implies, only caches database responses from your queries. Leaving your PHP code to do all of the dynamic stuff you want without needing to requery the database for every page load.

#### Implementing query caching

Database caching will greatly reduce the load on your database and increase the performance of your application as a result. It’s also easy to turn on. There are two settings in the database config file you need to modify. Just flip the `cache_on` switch and set a `cachedir` that is writable. With those options set you are up and running with database caching.

Once you have query caching up and running you will need to clear the caches whenever you do an update. Thanks to the convenient `cache_delete` function this too is very easy.

```php
$this->db->cache_delete('controller', 'method');
```

#### Possible issues

Database caching has a few quirks that may or may not be a problem for you:

 * **Uses an odd organization system.** Query cache files are organized into “controller+method” folders. This can be helpful, but if you have a single function in a controller that does some heavy lifting or runs different queries for different situations you may build up a very large pile of query cache files in short order.
 * **You have to specifically exclude queries from cache.** You can’t tell the system to only cache queries that you specifically want to cache, you tell the system to cache *all* queries then you can exclude individual queries with the `cache_off()` function.
 * **Can get messy easily.** You need to be very conscious about disabling cache for some queries to avoid a pile of useless cache files. It seems that if you’re using CodeIgniter’s DB sessions you will have a session query cached for every end user in every controller method folder, unless you extend it with custom code.
 * **Can’t purge cache for individual queries.** You have to evict cache files for all queries in a controller function if you want to delete a cache. Again if you have a few controller methods doing all the heavy lifting this can cause a problem. But hey, at least query caching *has* a delete function.
 * **No expiration/TTL.** Cache files can not be aged off. If you want a cache updated you must delete it.

The biggest problem is that the database caching simply isn’t sharp enough for many situations. The all-or-nothing structure can get annoying really quickly. If you’re going to use database sessions then you’re probably going to want to run a cron job to completely purge the cache every night.

### Third Party Caching

Several other more advanced and more flexible caching systems have been created by other CodeIgniter developers around the world. For some situations you may find them to be far better alternatives than the caching systems that CodeIgniter offers.

 * **[Phil Sturgeon’s Cache Library](http://philsturgeon.co.uk/code/codeigniter-cache)**

	An excellent and very flexible caching system that can be used with just about any object you would want. This system uses disk caching just like the output and database caching systems. You can cache model returns and library results in a serialized format that will greatly reduce the amount of database queries you need to run.

 * **[Jelmer Schreuder’s MP_Cache](https://bitbucket.org/mijnpraktijk/mp_cache/wiki/Home)**

	Another take on flexible caching, MP_Cache is a similar idea to Phil’s Cache Library but adds some more nice little features that you might enjoy, such as dependencies and group tags.

### Things I wish CodeIgniter supported

One day I’ll probably stop being lazy and extend the caching system to add these features, but until that day these are the biggest things that I wish EllisLab would implement in CodeIgniter’s caching system:

 * **Partial output caching.** This would be a huge, massive, zomgwtfwin improvement. Even if I could just use partial caching on views. Having main un-cached template view that calls individual cached content views would be immensely awesome. Cache just the content blocks with lots of heavy lifting beneath them and leave the lightweight user-specific stuff completely un-cached.
 * **Native output cache eviction.** One little function, say `clear_cache('controller/function')` would be very helpful. It is really troublesome to have to find cache files by their full URL. Any little modifier, say page-numbers, greatly complicates a search for cache files to delete. Not to mention that it just plain doesn’t make sense that the application has to know all of it’s possible URIs to purge cache files.
 * **Output cache groups.** Similar to the last idea, it would be nice to group related caches somehow, even just being able to specify a sub-directory to save them in would be enough. One example is paginated content. If I want to evict all caches for every page of a category I have to determine number of pages and the URIs for every page to delete all of the affected cache files. It would be nice to purge all of them as a group.
 * **Support for common caching back-ends.** It’s something I don’t really need to see in the library, but it would be nice if there was support for caching objects with the more popular PHP caching schemes such as APC.

### Conclusion

The caching systems in CodeIgniter have their pros and cons, and quirks, but the simplicity of the functions is nice in it’s own way, almost zen like in their simplicity. Of course I wish EllisLabs would improve and expand on this excellent base. Fortunately, thanks to the work of other developers we have some options for more complex caching needs.

So did I miss anything? Do you know of any other CI caching libraries that are worth mentioning here. Or do you know of any other techniques to squeeze some more flexibility out of the CI caching systems? I’d love to hear how you made caching work for your needs. Please add a comment below.
