INSERT INTO users (id, email, password_hash, name, role, created_at, updated_at) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'demo@fieldflow.app', '{noop}password', 'Demo User', 'ADMINISTRATOR', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'hanako@example.com', '{noop}password', '佐藤 花子', 'SUPERVISOR', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'taro@example.com', '{noop}password', '田中 太郎', 'OPERATOR', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO work_items (id, title, detail, status, priority, assignee_id, created_by, version, created_at, updated_at) VALUES
('11111111-1111-1111-1111-111111111111', '配送遅延の確認', '顧客から配送予定時刻の問い合わせ。物流チームへ状況確認が必要。', 'IN_PROGRESS', 'HIGH', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 4, TIMESTAMP '2024-06-01 09:00:00', TIMESTAMP '2024-06-01 10:00:00'),
('22222222-2222-2222-2222-222222222222', '店舗端末の交換依頼', 'レジ横の端末が再起動を繰り返している。現地確認後に交換判断。', 'PENDING', 'URGENT', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2, TIMESTAMP '2024-05-31 11:00:00', TIMESTAMP '2024-05-31 12:20:00'),
('33333333-3333-3333-3333-333333333333', '在庫差異レポート確認', '棚卸し結果とシステム在庫に差異あり。担当者確認待ち。', 'ON_HOLD', 'MEDIUM', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 7, TIMESTAMP '2024-05-29 09:00:00', TIMESTAMP '2024-05-29 11:13:20');

INSERT INTO activity_histories (id, work_item_id, actor_id, action, summary, created_at) VALUES
('11111111-aaaa-aaaa-aaaa-111111111111', '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'CREATED', 'WorkItemを作成しました', TIMESTAMP '2024-06-01 09:00:00'),
('11111111-bbbb-bbbb-bbbb-111111111111', '11111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'STATUS_UPDATED', 'ステータスを対応中に更新しました', TIMESTAMP '2024-06-01 10:00:00'),
('22222222-aaaa-aaaa-aaaa-222222222222', '22222222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'PRIORITY_UPDATED', '優先度を緊急に更新しました', TIMESTAMP '2024-05-31 12:20:00'),
('33333333-aaaa-aaaa-aaaa-333333333333', '33333333-3333-3333-3333-333333333333', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'CONFLICT_RESOLVED', '競合確認待ちにしました', TIMESTAMP '2024-05-29 11:13:20');
