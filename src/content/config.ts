import { defineCollection, z } from 'astro:content';

const postsCollection = defineCollection({
	type: 'content',
	schema: ({ image }) => z.object({
		title: z.string(),
		description: z.string().optional(),
		pubDate: z.date(),
		modDate: z.date(),
		image: z.object({
			src: image(),
			alt: z.string()
		}).optional(),
		categories: z.array(z.string()),
		tags: z.array(z.string())
	})
});

const commentsCollection = defineCollection({
	type: 'data',
	schema: z.array(
		z.object({
			author: z.number(),
			author_name: z.string(),
			author_url: z.string().optional(),
			date_gmt: z.string(),
			content: z.object({
				rendered: z.string()
			}),
			author_avatar_urls: z.object({
				48: z.string(),
			})
		})
	)
});

export const collections = {
	posts: postsCollection,
	comments: commentsCollection
};
