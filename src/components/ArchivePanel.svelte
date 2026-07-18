<script lang="ts">
import { onMount } from "svelte";

import I18nKey from "../i18n/i18nKey";
import { i18n } from "../i18n/translation";
import { getPostUrlBySlug } from "../utils/url-utils";
import { accentForLabel } from "../utils/accent-utils";

export let tags: string[];
export let categories: string[];
export let sortedPosts: Post[] = [];

const params = new URLSearchParams(window.location.search);
tags = params.has("tag") ? params.getAll("tag") : [];
categories = params.has("category") ? params.getAll("category") : [];
const uncategorized = params.get("uncategorized");

interface Post {
	slug: string;
	data: {
		title: string;
		tags: string[];
		category?: string;
		published: Date;
	};
}

interface Group {
	year: number;
	posts: Post[];
}

let groups: Group[] = [];

function formatDate(date: Date) {
	const month = (date.getMonth() + 1).toString().padStart(2, "0");
	const day = date.getDate().toString().padStart(2, "0");
	return `${month}-${day}`;
}

function formatTag(tagList: string[]) {
	return tagList.map((t) => `#${t}`).join(" ");
}

onMount(async () => {
	let filteredPosts: Post[] = sortedPosts;

	if (tags.length > 0) {
		filteredPosts = filteredPosts.filter(
			(post) =>
				Array.isArray(post.data.tags) &&
				post.data.tags.some((tag) => tags.includes(tag)),
		);
	}

	if (categories.length > 0) {
		filteredPosts = filteredPosts.filter(
			(post) => post.data.category && categories.includes(post.data.category),
		);
	}

	if (uncategorized) {
		filteredPosts = filteredPosts.filter((post) => !post.data.category);
	}

	const grouped = filteredPosts.reduce(
		(acc, post) => {
			const year = post.data.published.getFullYear();
			if (!acc[year]) {
				acc[year] = [];
			}
			acc[year].push(post);
			return acc;
		},
		{} as Record<number, Post[]>,
	);

	const groupedPostsArray = Object.keys(grouped).map((yearStr) => ({
		year: Number.parseInt(yearStr, 10),
		posts: grouped[Number.parseInt(yearStr, 10)],
	}));

	groupedPostsArray.sort((a, b) => b.year - a.year);

	groups = groupedPostsArray;
});
</script>

<div class="archive-panel card-base px-5 py-6 md:px-8">
    {#each groups as group}
        <section class="archive-year-group" aria-label={`${group.year} 年`}>
            <div class="archive-year-row flex flex-row w-full items-center h-[3.75rem]">
                <div class="archive-year-label w-[15%] md:w-[10%] transition text-xl md:text-2xl font-bold text-right text-75">
                    {group.year}
                </div>
                <div class="w-[15%] md:w-[10%]">
                    <div class="archive-year-marker mx-auto" aria-hidden="true"></div>
                </div>
                <div class="w-[70%] md:w-[80%] transition text-left text-50">
                    {group.posts.length} {i18n(group.posts.length === 1 ? I18nKey.postCount : I18nKey.postsCount)}
                </div>
            </div>

            {#each group.posts as post}
                <a
                        href={getPostUrlBySlug(post.slug)}
                        aria-label={post.data.title}
                        class="archive-entry group !block w-full hover:text-[initial]"
                        style={`--archive-accent: ${accentForLabel(post.data.category || post.data.title)}`}
                >
                    <div class="archive-row flex flex-row justify-start items-center h-full">
                        <!-- date -->
                        <div class="archive-date w-[15%] md:w-[10%] transition text-sm text-right text-50">
                            {formatDate(post.data.published)}
                        </div>

                        <!-- dot and line -->
                        <div class="archive-track w-[15%] md:w-[10%] relative h-full flex items-center">
                            <div class="archive-dot mx-auto" aria-hidden="true"></div>
                        </div>

                        <!-- post title -->
                        <div
                                class="archive-title w-[70%] md:max-w-[65%] md:w-[65%] text-left font-bold
                     transition-all text-75 pr-4 md:pr-8 whitespace-nowrap overflow-ellipsis overflow-hidden"
                        >
                            {post.data.title}
                        </div>

                        <!-- tag list -->
                        <div
                                class="archive-tags hidden md:block md:w-[15%] text-left text-sm transition
                     whitespace-nowrap overflow-ellipsis overflow-hidden text-30"
                        >
                            {formatTag(post.data.tags)}
                        </div>
                    </div>
                </a>
            {/each}
        </section>
    {/each}
</div>

<style>
    .archive-year-group + .archive-year-group {
        margin-top: 1.35rem;
    }

    .archive-year-label {
        padding-right: 0.4rem;
        letter-spacing: -0.04em;
    }

    .archive-year-marker {
        position: relative;
        z-index: 2;
        width: 0.9rem;
        height: 0.9rem;
        border: 1px solid color-mix(in srgb, var(--primary) 72%, var(--neu-border));
        border-radius: 50%;
        background: linear-gradient(145deg, var(--surface-high), var(--card-bg));
        box-shadow:
            3px 3px 7px var(--neu-shadow),
            -2px -2px 5px var(--neu-highlight),
            inset 1px 1px 1px var(--neu-highlight-strong);
    }

    .archive-entry {
        position: relative;
        min-height: 3.1rem;
        margin: 0.45rem 0;
        padding: 0.28rem 0.35rem;
        border: 1px solid transparent;
        border-radius: 1rem;
        background: transparent;
        transition:
            transform 190ms cubic-bezier(0.22, 1, 0.36, 1),
            box-shadow 190ms ease,
            background-color 190ms ease,
            border-color 190ms ease;
    }

    .archive-entry:hover,
    .archive-entry:focus-visible {
        z-index: 3;
        outline: none;
        border-color: var(--neu-border);
        background: linear-gradient(145deg, var(--surface-high), var(--card-bg));
        box-shadow:
            8px 8px 17px var(--neu-shadow-strong),
            -6px -6px 13px var(--neu-highlight-strong),
            inset 1px 1px 1px var(--neu-highlight-strong);
        transform: translateY(-3px);
    }

    .archive-entry:focus-visible {
        outline: 2px solid color-mix(in srgb, var(--archive-accent) 55%, transparent);
        outline-offset: 2px;
    }

    .archive-entry:active {
        transform: translateY(1px);
        background: var(--surface-low);
        box-shadow:
            inset 3px 3px 7px var(--neu-inset-shadow),
            inset -3px -3px 7px var(--neu-inset-highlight);
    }

    .archive-row {
        min-height: 2.5rem;
    }

    .archive-date {
        padding: 0.28rem 0.45rem 0.28rem 0.2rem;
        border-radius: 0.65rem;
        transition: box-shadow 190ms ease, background-color 190ms ease, color 190ms ease;
    }

    .archive-entry:hover .archive-date,
    .archive-entry:focus-visible .archive-date {
        color: color-mix(in srgb, var(--surface-text) 70%, transparent);
        background: var(--surface-low);
        box-shadow:
            inset 2px 2px 5px var(--neu-inset-shadow),
            inset -2px -2px 5px var(--neu-inset-highlight);
    }

    .archive-track::before {
        content: "";
        position: absolute;
        top: -0.9rem;
        bottom: -0.9rem;
        left: 50%;
        width: 2px;
        transform: translateX(-50%);
        background: var(--line-divider);
        box-shadow: 1px 0 0 var(--neu-highlight);
    }

    .archive-dot {
        position: relative;
        z-index: 2;
        width: 0.42rem;
        height: 0.42rem;
        border: 0.2rem solid var(--card-bg);
        box-sizing: content-box;
        border-radius: 999px;
        background: var(--archive-accent);
        box-shadow:
            2px 3px 6px color-mix(in srgb, var(--archive-accent) 32%, var(--neu-shadow)),
            inset 1px 1px 1px rgba(255, 255, 255, 0.48);
        transition: height 190ms cubic-bezier(0.22, 1, 0.36, 1), box-shadow 190ms ease;
    }

    .archive-entry:hover .archive-dot,
    .archive-entry:focus-visible .archive-dot {
        height: 1.45rem;
        box-shadow:
            3px 4px 8px color-mix(in srgb, var(--archive-accent) 38%, var(--neu-shadow)),
            inset 1px 1px 1px rgba(255, 255, 255, 0.52);
    }

    .archive-title {
        transition: transform 190ms cubic-bezier(0.22, 1, 0.36, 1), color 190ms ease;
    }

    .archive-entry:hover .archive-title,
    .archive-entry:focus-visible .archive-title {
        color: var(--archive-accent);
        transform: translateX(0.35rem);
    }

    .archive-tags {
        padding: 0.25rem 0.5rem;
        border-radius: 0.6rem;
        transition: box-shadow 190ms ease, background-color 190ms ease, color 190ms ease;
    }

    .archive-entry:hover .archive-tags,
    .archive-entry:focus-visible .archive-tags {
        color: var(--archive-accent);
        background: color-mix(in srgb, var(--surface-low) 72%, var(--card-bg));
        box-shadow:
            inset 2px 2px 4px var(--neu-inset-shadow),
            inset -2px -2px 4px var(--neu-inset-highlight);
    }

    @media (max-width: 767px) {
        .archive-entry {
            margin-block: 0.35rem;
            padding-inline: 0.2rem;
        }

        .archive-year-label,
        .archive-date {
            padding-right: 0.2rem;
        }
    }

    @media (prefers-reduced-motion: reduce) {
        .archive-entry,
        .archive-date,
        .archive-dot,
        .archive-title,
        .archive-tags {
            transition: none;
        }
    }
</style>
