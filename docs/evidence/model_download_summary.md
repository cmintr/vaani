# Model download summary

The private Vaani app uses a manifest-first model install path for the local LLM
bundle.

## Measured artifact

| Item | Value |
|---|---|
| Model | `gemma-4-E4B-it.litertlm` |
| Size | 3,659,530,240 bytes / 3.41 GiB |
| Transport | 4 verified shards |
| Commit model | Same-volume atomic rename where available; two-stage fallback otherwise |
| Terminal-ready rule | App model path is written only after full verification |

## Integrity checks

- Shard byte count.
- Shard SHA256.
- Final bundle SHA256.
- NOTICE hash.
- Rename atomicity probe.
- Staging cleanup/recovery.

