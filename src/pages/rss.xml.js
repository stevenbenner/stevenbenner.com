import rss from '@astrojs/rss';
import sanitizeHtml from 'sanitize-html';
import MarkdownIt from 'markdown-it';
import { getCollection } from 'astro:content';
import { site } from '../data/config.json';

const parser = new MarkdownIt({ html: true });

export async function GET(context) {
	const postsCollection = await getCollection('posts');
	return rss({
		title: site.name,
		description: site.description,
		site: context.site,
		customData: `<language>${site.language}</language>`,
		items: postsCollection.toSorted((a, b) => (
			b.data.pubDate.valueOf() - a.data.pubDate.valueOf()
		)).map((post) => ({
			link: `/${post.slug}/`,
			content: sanitizeHtml(parser.render(post.body)),
			...post.data,
			...{ categories: post.data.categories.concat(post.data.tags) }
		}))
	});
}
