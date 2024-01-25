# StevenBenner.com

**Source code for the StevenBenner.com web site.**

This project is my personal blog website, [StevenBenner.com][website]. It is based on the [Astro][astro] web framework and is designed for deployment as a static site.

This software is licensed under the [Mozilla Public License, Version 2.0][license].

[website]: https://stevenbenner.com/
[astro]: https://astro.build/
[license]: LICENSE.txt

## Run this project locally

This project runs in [Node.js][node]. So long as you have node and npm installed then you can run this project locally with the following commands:

 1. `npm ci` (clean-install, only needed for the first run)
 2. `npm run dev`

You can then view the local server at: http://localhost:4321/

[node]: https://nodejs.org/

## Add content

### Create new post

The posts are simply files in a folder. There is no metadata or lists to maintain. Just make sure the files are named so that they are sorted by post date.

 1. Create a new markdown file in the `src/content/posts` folder with a filename in the format of "YYYY-MM-DD-slug.md".
 2. Add the YAML frontmatter document information. (The data in the `---` block at the beginning of the file.)
 3. Set the `pubDate` to the current date and time in ISO 8601 format.

	Get the current ISO 8601 datetime with this command: `date -u +'%Y-%m-%dT%H:%M:%SZ'`

### Create comment

Comments are in JSON files in the `src/content/comments` folder. They must have the same file name as the post that they are for, except for the file extension which should be `.json`. The simplest way to create a new comment is to copy and paste an existing comment and update the values.

Gravatar image URLs are a hash of your email address. To get your email hash run this command:

 * `echo -n 'youremail@example.com' | md5sum | cut -d' ' -f1`

## Commands

All commands are run from the root of the project, from a terminal:

| Command           | Action                                        |
| :---------------- | :-------------------------------------------- |
| `npm run dev`     | Start local dev server at `localhost:4321`    |
| `npm run build`   | Build production site in `./dist/`            |
| `npm run preview` | Preview the build locally at `localhost:4321` |
