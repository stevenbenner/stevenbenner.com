---
title: 'Uprading from MediaWiki 1.6.12'
description: 'This is a guide to fixing the MediaWiki 1.15.1+ upgrade warning “you requested the mysql5-binary schema, but the existing database has the mysql4 schema”.'
slug: 2009/08/uprading-from-mediawiki-1-6-12
pubDate: 2009-08-28T04:26:41Z
modDate: 2010-03-07T20:58:04Z
image:
  src: '../../assets/thumbnails/wikipedia-logo.png'
  alt: 'Wikipedia logo'
categories:
- Web Development
tags:
- How-To
- MySQL
- PHP
- SQL
---

Recently I had to upgrade an install of [MediaWiki](http://www.mediawiki.org/) from version 1.6.12 to the latest version. It was originally installed on a host that only had PHP4 and MySQL4. The 1.6.x versions of MediaWiki were the last to support PHP 4. We were moving the site to a new server with PHP5 and MySQL5 so it was time to upgrade to the latest release of MediaWiki, version 1.15.1.

I selected to use the new binary database format during install. After copying over the database and running the upgrade script I came across an interesting error:

 > Warning: you requested the mysql5-binary schema, but the existing database has the mysql4 schema. This upgrade script can’t convert it, so it will remain mysql4.

<!-- more -->

Now this is really just a minor problem, it wont affect the functionality of your wiki install at all. However, binary data makes more sense than the old UTF-8 format for a couple of reasons:

 * Characters are stored exactly as they are entered, so if you use non-English or unusual characters often they will be better preserved.  In MySQL 4, the UTF-8 format only covered characters in the [Basic Multilingual Plane](https://en.wikipedia.org/wiki/Mapping_of_Unicode_character_planes) (BMP). Anything outside of those standard characters would be saved as jibberish if you did a mysqldump of the database.
 * Binary text data is faster to search through, since it is always a direct binary comparison.

So I wanted to convert the database to the new binary schema, but the upgrade script cannot change the character sets or collations on the tables. Since I was actually moving servers I didn’t have to do the whole thing in a live SQL database, so decided to accomplish this by doing a two-step update.

I simply crafted a basic table layout based on the latest MediaWiki database schema that would accept the data from the old wiki but have the latest data types and default charset attached to each table. While doing this I noticed numerous little things that changed but weren’t updated by the upgrade script. Little things like the number of character for a column. Columns that only supported 10 characters in the old wiki schema were supposed to support 14 in the new wiki schema, but the upgrade script couldn’t change these. I doubt they would ever be a real issue, but I wanted to go with the latest schema in every detail.

In the end I came up with an interim table structure that I could use to import all of the data exported from the old wiki using mysqldump, but could be completely updated to the latest schema using the upgrade script built into MediaWiki.

Download the schema SQL file here:

 * [mediawiki-convertion-schema](/misc/mediawiki-convertion-schema.zip)

To upgrade your wiki database from 1.6.12 to 1.15.1 follow these simple steps:

 1. Do a database dump of your existing wiki database
 2. Open the mediawiki-conversion-schema SQL file linked above and change the following items:
     * Replace all occurrences of “DATABASE_NAME” with the name of your new wiki database.
     * Update the AUTO_INCREMENT values on each table to those of your current wiki database (you can find these values in your database dump).
 3. Now go through your database dump from the old wiki and remove all of the CREATE TABLE statements. You just want the INSERT statements.
 4. Run your modified mediawiki-conversion-schema.sql (“mysql < mediawiki-conversion-schema.sql -p”). This will create the interim table structure.
 5. Run your modified database dump SQL file (“mysql < mydatadump.sql -p”). This will import all of your old data into the new, upgradeable database.
 6. Then run the mediawiki upgrade script on that database.

It’s pretty straightforward, you create an interim database with the latest binary data types but only the columns from the old schema. This allows you to import your old data into the interim database. You can then use the regular MediaWiki upgrade process to finish the database structure and clean up the data.

That’s it. You now have completely upgraded from the old database schema to the latest and greatest. I hope someone out there finds this useful!
