# Memory system summary

Vaani's memory system is designed for on-device hybrid retrieval.

| Component | Value |
|---|---|
| Embeddings | EmbeddingGemma 300M |
| Dimension | 768D |
| Vector store | sqlite-vec |
| Lexical search | FTS5/BM25 |
| Fusion | Reciprocal-rank fusion (`k=60`) |

## Retrieval intent

Semantic search handles approximate recall. BM25/FTS5 catches exact names,
proper nouns and lexical details. RRF merges both without requiring a cloud
memory API.

