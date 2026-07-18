export const ACCENT_PALETTE = [
	"var(--primary)",
	"var(--accent-cyan)",
	"var(--accent-coral)",
	"var(--accent-mint)",
] as const;

const CATEGORY_ACCENTS: Record<string, (typeof ACCENT_PALETTE)[number]> = {
	"AI 与工具": "var(--accent-cyan)",
	"学习与项目": "var(--primary)",
	"游戏与体验": "var(--accent-coral)",
	生活随记: "var(--accent-mint)",
};

/**
 * 为分类、文章卡片和归档条目提供同一套稳定强调色。
 * 已知分类使用固定语义色；新分类按名称稳定分配，不需要在文章中手写颜色。
 */
export function accentForLabel(label: string) {
	const normalizedLabel = label.trim();
	if (CATEGORY_ACCENTS[normalizedLabel]) {
		return CATEGORY_ACCENTS[normalizedLabel];
	}

	const seed = [...normalizedLabel].reduce(
		(total, character) => total + (character.codePointAt(0) || 0),
		0,
	);
	return ACCENT_PALETTE[seed % ACCENT_PALETTE.length];
}
