/**
 * Custom Compaction Extension
 *
 * Uses opencode/deepseek-v4-flash-free for compaction summarization
 * instead of the default conversation model. Falls back to default
 * compaction if the model is unavailable or an error occurs.
 *
 * Registered as an extension in ~/.config/pi/agent/settings.json
 */

import { compact } from "@earendil-works/pi-coding-agent";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.on("session_before_compact", async (event, ctx) => {
		const { preparation, signal } = event;

		// Find the dedicated compaction model
		const model = ctx.modelRegistry.find("opencode", "deepseek-v4-flash-free");
		if (!model) {
			ctx.ui.notify(
				"Compaction model 'opencode/deepseek-v4-flash-free' not found, using default",
				"warning",
			);
			return; // fall back to default compaction
		}

		// Resolve API key and request headers for the model
		const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
		if (!auth.ok) {
			ctx.ui.notify(`Compaction auth failed: ${auth.error}`, "warning");
			return; // fall back to default compaction
		}

		try {
			const result = await compact(
				preparation,
				model,
				auth.apiKey,
				auth.headers,
				undefined, // customInstructions
				signal,
				undefined, // thinkingLevel
				undefined, // streamFn
				auth.env,
			);

			ctx.ui.notify(
				`Compacted with opencode/deepseek-v4-flash-free (${result.tokensBefore.toLocaleString()} tokens summarized)`,
				"info",
			);

			return { compaction: result };
		} catch (error) {
			const message = error instanceof Error ? error.message : String(error);
			ctx.ui.notify(`Compaction failed: ${message}, falling back to default`, "warning");
			return; // fall back to default compaction
		}
	});
}
