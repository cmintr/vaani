# Architecture

Vaani is a pre-release local-first Android AI companion. The private app is a
Flutter/Kotlin/Rust Android project with on-device inference, voice-command
tooling and hybrid memory.

Visual overview: [docs/assets/architecture.svg](docs/assets/architecture.svg) and
[docs/architecture.html](docs/architecture.html).

## High-level flow

```text
User voice/text
  -> Flutter UI / conversation orchestrator
  -> STT path for voice turns
  -> local tool classifier and cloud-tool gate
  -> LiteRT-LM local LLM generation
  -> tool execution or deferred cloud-tool envelope
  -> Rust memory retrieval over sqlite-vec + FTS5/BM25
  -> TTS / UI response
```

## Key design choices

### Local-first, not "pretend offline"

Cloud-only tools are not silently executed or faked when no cloud key is
available. They produce a deferred envelope. Local tools such as reminders,
notes, calendar and memory remain local.

### Hybrid memory

The memory system combines:

- EmbeddingGemma 300M 768D semantic vectors.
- sqlite-vec for vector search.
- FTS5/BM25 for lexical and proper-noun recall.
- Reciprocal-rank fusion (`k=60`) to merge semantic and lexical candidates.

### Manifest-first model install

The local model is treated as a verified artifact, not a loose download:

- Sharded transfer with byte and SHA256 checks.
- Final bundle hash verification.
- NOTICE verification.
- Same-volume atomic commit when available.
- Two-stage fallback when atomic rename is unavailable.
- App setting updated only after terminal-ready verification.

### QA as product infrastructure

Voice and tool behavior is validated through Appium/logcat harnesses. A voice
turn is not considered passing merely because text appears; the harness checks
tool invocation and DB side effects.

## What is intentionally absent

- Full private source.
- Model binaries.
- API-key handling.
- Local paths and private logs.
- Personal memory/persona content.
- Vendor/customer program detail.
- Internal coordination history.
