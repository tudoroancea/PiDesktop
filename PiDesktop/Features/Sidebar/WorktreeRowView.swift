import SwiftUI

struct WorktreeRowView: View {
  let name: String
  let addedLines: Int?
  let removedLines: Int?
  let sessionStatus: SessionStatus

  var body: some View {
    HStack(spacing: 8) {
      // Status indicator
      statusIndicator

      // Worktree/branch name
      Text(name)
        .font(.system(size: 13))
        .foregroundStyle(RosePine.text)
        .lineLimit(1)
        .truncationMode(.middle)

      Spacer()

      // Diff stats
      if let added = addedLines, let removed = removedLines, (added > 0 || removed > 0) {
        HStack(spacing: 4) {
          if added > 0 {
            Text("+\(added)")
              .font(.system(size: 11, design: .monospaced))
              .foregroundStyle(RosePine.diffAdded)
          }
          if removed > 0 {
            Text("-\(removed)")
              .font(.system(size: 11, design: .monospaced))
              .foregroundStyle(RosePine.diffRemoved)
          }
        }
      }
    }
    .padding(.vertical, 2)
    .contentShape(Rectangle())
  }

  @ViewBuilder
  private var statusIndicator: some View {
    switch sessionStatus {
    case .running:
      Circle()
        .fill(RosePine.statusRunning)
        .frame(width: 8, height: 8)
        .help("Pi session running")
    case .idle:
      Circle()
        .fill(RosePine.statusIdle)
        .frame(width: 8, height: 8)
        .help("Pi session idle")
    case .terminal:
      Circle()
        .fill(RosePine.statusTerminal)
        .frame(width: 8, height: 8)
        .help("Terminal open (no pi session)")
    case .stopped:
      Circle()
        .strokeBorder(RosePine.statusStopped, lineWidth: 1)
        .frame(width: 8, height: 8)
        .help("No active session")
    }
  }
}
