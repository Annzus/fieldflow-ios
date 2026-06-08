import SwiftUI

struct WorkItemRowView: View {
    let item: WorkItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Text(item.priority.displayName)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }

            HStack(spacing: 10) {
                Label(item.status.displayName, systemImage: "flag")
                Label(PreviewData.memberName(for: item.assigneeID), systemImage: "person")
                Spacer()
                Text(item.syncState.displayName)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }
}
