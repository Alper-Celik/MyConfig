# Working preferences

## Prefer MCP / documentation tools over running code

- Answer questions from documentation before writing or reading code. Use the mounted MCP servers: Context7 (`resolve-library-id` then `query-docs`) for library/framework/CLI/API docs, the native `github` tool for repository metadata (repos, issues, PRs, releases, Actions logs, file contents) with `gh` in `bash` for the ops it lacks (issue/PR comments, reviews, merge, labels, releases, notifications), codebase-memory graph tools (`search_graph`, `get_architecture`, `trace_path`, `get_code_snippet`, `query_graph`) for structural code questions, Exa/`web_search` for the open web.
- Code search: the native `github` tool (`search_code`) or `gh search code` for GitHub-indexed code, Exa/`web_search` for the open web. Read the exact revision with `file_read`/`read` when the answer must come from one repository, commit, tag, or released version.
- Do not substitute shell pipelines, `curl`/`wget`, ad-hoc scripts, `git` archaeology, or scraping raw doc URLs for a tool that answers the same question directly.
- Use the purpose-built tools instead of shell equivalents: `read`/`glob`/`grep`/`edit`/`lsp`/`ast_grep` for files, search, and refactors; `bash` only for real binaries and short fact pipelines.
- Do not reproduce by hand what an MCP tool or a single targeted command can answer.

## Do not overdo verification or tests

- Verify the change itself, once, with the smallest thing that exercises it: run the command, hit the endpoint, eval the expression. No full test suites, no repo-wide builds, no end-to-end harness runs unless explicitly asked.
- Never re-verify an edit that already applied; never run git commands just to confirm work.
- Never start a long verification without asking first. Anything that can plausibly run longer than a minute or two — full builds, `nix build` of a system configuration, whole test suites, end-to-end or integration harnesses, container image builds, deploys, benchmarks, scripts over large trees, repeated polling loops — must be proposed before it runs: say what you intend to run, why it is needed, and roughly how long it takes, then wait for a go-ahead. If you are unsure whether something counts as long, state the plan and ask.
- Keep the user informed rather than silently grinding: before launching a command, say what it does and why; if it must run anyway, report the outcome in one line when it finishes. Never leave a multi-minute job unmentioned.
- When told the user will deploy or verify, stop verifying and hand off.
- Add a test only for a genuinely uncertain edge case or on request. Never add tests so a change "has tests". Delete dead or convention-breaking tests instead of re-pinning them.
- Prove claims with the evidence that produced them (command output, file and line, docs excerpt); mark anything unobserved as inference.

## Scope discipline

- Do exactly what was asked. No opportunistic refactors, new abstractions, retries, validation layers, telemetry, or "while I'm here" changes.
- Follow the conventions already in the repository; do not introduce a second convention next to an existing one.
- Report tersely: what changed, how it was verified, what is still open.

## Match the prompt: scoped and decisive means execute, don't explore

When the prompt is scoped and decisive ("just do it", "add X", "convert these to that", "move things to the new convention"), work like `sed` with natural language: make exactly that change, run the smallest check that exercises it, report, stop.

- No rabbit holes. Don't validate adjacent infrastructure, don't reverse-engineer the app's setup to build a smoke harness, don't chase curiosities that surface along the way — unless the asked change genuinely cannot be made without that information.
- Verification for these prompts = compile + format check, plus the smallest smoke test that exercises the change. If the smoke test needs app configuration the harness lacks, replicate the missing lines once (find them with one targeted grep) or skip the smoke test and say so in one line. Never turn that into a multi-step investigation.
- Anything discovered outside the asked scope gets one line at the end of the report, not a detour.

## Git commits

- Inside worktrees under `~/.omp/wt/`, you are free to commit without asking; always commit your changes there (leave the worktree dirty only on failure).
- Every commit carries both parties. If the commit's author is Alper (his change, you committing it), append `Co-authored-by: Alper-Celiks-Agent <agent@alper-celik.dev>`; if you are the author, append `Co-authored-by: Alper Çelik <alper@alper-celik.dev>`. Use `git commit --trailer` rather than editing the message by hand. Identities: agent = `GIT_CONFIG_GLOBAL` set by `Configs/scripts/omp-sandboxed`; Alper = `Configs/Git.home.nix`.

## Memory is shared with the Hermes agent

- The long-term memory (Hindsight-backed `retain`/`recall`/`reflect`, memory banks, mental models) is shared between this agent and Alper's Hermes agent. Facts learned in one session are visible to the other — never assume memory entries were written by you specifically, and never store agent-private credentials or anything you would not want crossing agents.
- Recall aggressively ("spam" it): before starting work, when context seems thin, or when a preference or past decision might exist, call `recall`/`reflect` rather than asking Alper to repeat himself. Cheap queries, expensive re-explanations.

## Offloading work to the Hermes agent

- Hermes runs server-side on hetzner-server-1 as an OpenAI-compatible API: `https://hermes-api.lab.alper-celik.dev/v1`, model `hermes-agent`, key via `bash ~/.omp/agent/hermes-key.sh` (also registered as omp provider `hermes`, so `task` subagents can use `model: "hermes/hermes-agent"`).
- Use it when a task belongs on the always-on server, or as a more relaxed test surface: Hermes runs as its own user with a wider sandbox than this agent's firejail (network, nix daemon, system paths) — good for tests this sandbox cannot run.

## Hermes offload — verified behavior

- VERIFIED (2026-10-11): the API is strictly synchronous. Killing the client connection mid-run CANCELS the agent run server-side (tool side effects never happen). Never promise Alper "it will finish after you close the laptop" via this endpoint.
- Therefore: offload via this API only while the laptop stays up, with a generous curl/task timeout. For true laptop-off offload, no supported path exists yet — options are Hermes' webhook/telegram channels or adding a server-side queue.
