// omp's syntect bundle (crates/natives/src/syntaxes/builder.rs) has no Dart
// grammar, so dart fences render plain. Alias them to TypeScript, whose token
// set closely matches Dart (classes, generics, async/await, arrow functions,
// annotations). Display-only: the session, exports and model context keep
// ```dart. Drop this file once omp bundles a real Dart sublime-syntax.
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

export default function dartFenceAlias(pi: ExtensionAPI) {
	pi.setLabel("Dart fence highlight");
	pi.registerAssistantTextRenderer(({ text }) =>
		text.replace(/^(\s*```+)dart(\s*)$/gm, "$1typescript$2"),
	);
}
