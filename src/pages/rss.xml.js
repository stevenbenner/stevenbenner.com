import rss from '@astrojs/rss';
import sanitizeHtml from 'sanitize-html';
import MarkdownIt from 'markdown-it';
import { getCollection } from 'astro:content';
import { site } from '../data/config.json';

const parser = new MarkdownIt();

export async function GET(context) {
	const postsCollection = await getCollection('posts');
	return rss({
		title: site.name,
		description: site.description,
		site: context.site,
		items: postsCollection.map((post) => ({
			link: `/${post.slug}/`,
			customData: '<language>en-US</language>',
			content: sanitizeHtml(parser.render(post.body)),
			...post.data
		}))
	});
}
