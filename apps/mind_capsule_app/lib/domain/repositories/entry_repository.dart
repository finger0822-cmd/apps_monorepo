import '../models/mind_entry.dart';

/// エントリ（日記）の永続化・取得を抽象化するリポジトリ
abstract class EntryRepository {
  // ── 書き込み ──────────────────────────────────
  Future<void> save(MindEntry entry);
  Future<void> update(MindEntry entry);
  Future<bool> delete(int id);
  // ── 読み込み ──────────────────────────────────
  Future<List<MindEntry>> getAll();
  Future<MindEntry?> getById(int id);
  Future<List<MindEntry>> getRecent(int limit);
  // ── AI分析 ───────────────────────────────────
  Future<String?> fetchAiFeedback(int id, String language);
  Future<String?> fetchAiPeriodAnalysis(
    List<int> entryIds,
    int days,
    String language,
  );
  Future<String?> fetchAiComparison(int id, String language);

  // ── タイムカプセル ─────────────────────────────
  Future<List<MindEntry>> getSealedCapsules();
  Future<List<MindEntry>> getOpenedCapsules();
  Future<void> openDueCapsules();
}
