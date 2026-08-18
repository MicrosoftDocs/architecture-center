---
---

## Posting a body to a safe-output tool

When you call a `safeoutputs` tool that takes a `body` (for example, `add_comment` or `update_pull_request`), the posted body must contain your full, intended text with its Markdown and line breaks intact. Treat that as the requirement; choose whatever invocation reliably achieves it.

Watch for these failure modes, which post a corrupted body while still reporting success:

- Passing the body as a raw command-line flag value. Multi-line and Markdown text are unreliable this way; the shell can truncate or mangle them. In particular, the CLI doesn't treat `--body -` as "read from stdin" — it posts a body that is the literal character `-`, which renders as an empty bullet.
- Any path that loses newlines, unescapes characters, or drops content.

A reliable technique is to pass the body as JSON on stdin so it's escaped correctly, for example `jq -n --arg body "$COMMENT_BODY" --argjson n 12345 '{item_number:$n, body:$body}' | safeoutputs add_comment .`. Use it or any equivalent approach that preserves the body faithfully.

## Checking the result of a safe-output tool call

Always capture and read the full output of a `safeoutputs` call before assuming it succeeded. Never pipe it through `head` as the CLI prints a multi-line startup preamble (bridge invocation, echoed arguments, MCP handshake) before the actual result or error line, so `head` can truncate the output before you ever see a failure.

A common failure this catches: calling `update_pull_request` with a bad parameter name like `pull_number` instead of the correct value. The tool rejects this with a JSON-RPC error (`unknown parameter 'pull_number'`). If that error is hidden by a truncated `head`, you'll wrongly conclude the update succeeded and move on, leaving the PR body unchanged.
