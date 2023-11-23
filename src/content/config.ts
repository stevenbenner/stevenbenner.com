import { defineCollection, z } from 'astro:content';

const postsCollection = defineCollection({
	type: 'content',
	schema: ({ image }) => z.object({
		title: z.string(),
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

export const collections = {
	posts: postsCollection
};
