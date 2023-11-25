import { defineConfig } from 'astro/config';
import { site } from './src/data/config.json';

export default defineConfig({
	site: site.url
});
