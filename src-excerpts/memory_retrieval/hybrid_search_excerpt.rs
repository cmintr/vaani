// What it does: Merges sqlite-vec semantic results with FTS5/BM25 lexical results.
// Why this design: Personal memory needs both meaning-level recall and exact-name recall.
// What it proves: Hybrid RAG can run locally on Android without a cloud memory API.

use std::collections::HashMap;

const RRF_K: f64 = 60.0;

fn reciprocal_rank_score(rank_zero_based: usize) -> f64 {
    1.0 / (RRF_K + (rank_zero_based + 1) as f64)
}

fn add_ranked_results(scores: &mut HashMap<i64, f64>, ranked_rowids: &[i64]) {
    for (rank, rowid) in ranked_rowids.iter().enumerate() {
        let rrf = reciprocal_rank_score(rank);
        scores
            .entry(*rowid)
            .and_modify(|score| *score += rrf)
            .or_insert(rrf);
    }
}

fn fuse_vector_and_bm25(vector_rowids: &[i64], bm25_rowids: &[i64], k: usize) -> Vec<i64> {
    let mut scores = HashMap::new();

    add_ranked_results(&mut scores, vector_rowids);
    add_ranked_results(&mut scores, bm25_rowids);

    let mut ranked: Vec<(i64, f64)> = scores.into_iter().collect();
    ranked.sort_by(|a, b| b.1.partial_cmp(&a.1).unwrap());
    ranked.truncate(k);

    ranked.into_iter().map(|(rowid, _score)| rowid).collect()
}

// In the private app, vector_rowids come from sqlite-vec over 768D
// EmbeddingGemma vectors, and bm25_rowids come from an FTS5 table joined to the
// memory metadata table. Deleted, archived and unvalidated memories are filtered
// before fusion.

