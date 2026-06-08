import Foundation

enum PreviewData {
    static let currentUserID = UUID()
    static let storeMemberID = UUID()
    static let logisticsMemberID = UUID()

    static let members: [Member] = [
        Member(id: storeMemberID, name: "佐藤 花子", role: .supervisor),
        Member(id: logisticsMemberID, name: "田中 太郎", role: .operatorUser)
    ]

    static let workItems: [WorkItem] = [
        WorkItem(
            id: UUID(),
            title: "配送遅延の確認",
            detail: "顧客から配送予定時刻の問い合わせ。物流チームへ状況確認が必要。",
            status: .inProgress,
            priority: .high,
            assigneeID: logisticsMemberID,
            createdBy: currentUserID,
            createdAt: Date(timeIntervalSince1970: 1_717_200_000),
            updatedAt: Date(timeIntervalSince1970: 1_717_203_600),
            serverVersion: 4,
            localVersion: 4,
            syncState: .synced
        ),
        WorkItem(
            id: UUID(),
            title: "店舗端末の交換依頼",
            detail: "レジ横の端末が再起動を繰り返している。現地確認後に交換判断。",
            status: .pending,
            priority: .urgent,
            assigneeID: storeMemberID,
            createdBy: currentUserID,
            createdAt: Date(timeIntervalSince1970: 1_717_120_000),
            updatedAt: Date(timeIntervalSince1970: 1_717_124_800),
            serverVersion: 2,
            localVersion: 3,
            syncState: .pending
        ),
        WorkItem(
            id: UUID(),
            title: "在庫差異レポート確認",
            detail: "棚卸し結果とシステム在庫に差異あり。担当者確認待ち。",
            status: .onHold,
            priority: .medium,
            assigneeID: storeMemberID,
            createdBy: currentUserID,
            createdAt: Date(timeIntervalSince1970: 1_716_940_000),
            updatedAt: Date(timeIntervalSince1970: 1_716_948_000),
            serverVersion: 7,
            localVersion: 7,
            syncState: .conflict
        )
    ]

    static func memberName(for id: UUID?) -> String {
        guard let id else {
            return "未割当"
        }
        return members.first { $0.id == id }?.name ?? "未割当"
    }
}
