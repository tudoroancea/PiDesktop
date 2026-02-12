import SwiftUI

struct AppShortcut {
  let key: Character
  let modifiers: EventModifiers

  var keyEquivalent: KeyEquivalent {
    KeyEquivalent(key)
  }

  var keyboardShortcut: KeyboardShortcut {
    KeyboardShortcut(keyEquivalent, modifiers: modifiers)
  }

  /// Ghostty keybind string for unbinding, e.g. "ctrl+super+g"
  var ghosttyKeybind: String {
    let parts = ghosttyModifierParts + [String(key).lowercased()]
    return parts.joined(separator: "+")
  }

  var display: String {
    let parts = displayModifierParts + [String(key).uppercased()]
    return parts.joined()
  }

  private var ghosttyModifierParts: [String] {
    var parts: [String] = []
    if modifiers.contains(.control) { parts.append("ctrl") }
    if modifiers.contains(.option) { parts.append("alt") }
    if modifiers.contains(.shift) { parts.append("shift") }
    if modifiers.contains(.command) { parts.append("super") }
    return parts
  }

  private var displayModifierParts: [String] {
    var parts: [String] = []
    if modifiers.contains(.command) { parts.append("⌘") }
    if modifiers.contains(.shift) { parts.append("⇧") }
    if modifiers.contains(.option) { parts.append("⌥") }
    if modifiers.contains(.control) { parts.append("⌃") }
    return parts
  }
}

enum AppShortcuts {
  // Tab creation
  static let newShellTab = AppShortcut(key: "n", modifiers: [.command, .shift])
  static let newPiTab = AppShortcut(key: "n", modifiers: [.command, .control])
  static let closeTab = AppShortcut(key: "w", modifiers: [.command])
  static let closeWindow = AppShortcut(key: "w", modifiers: [.command, .shift])

  // Tab navigation
  static let nextTab = AppShortcut(key: "]", modifiers: [.command, .control])
  static let previousTab = AppShortcut(key: "[", modifiers: [.command, .control])

  // Tool tabs
  static let openLazygit = AppShortcut(key: "g", modifiers: [.command, .control])
  static let openLumenDiff = AppShortcut(key: "d", modifiers: [.command, .control])

  // External apps
  static let openInZed = AppShortcut(key: "z", modifiers: [.command, .control])

  // Sidebar
  static let toggleSidebar = AppShortcut(key: "s", modifiers: [.command, .control])
  static let focusSidebar = AppShortcut(key: "0", modifiers: [.command, .control])

  // Tab switching (Cmd+Ctrl+1-9)
  static let selectTab1 = AppShortcut(key: "1", modifiers: [.command, .control])
  static let selectTab2 = AppShortcut(key: "2", modifiers: [.command, .control])
  static let selectTab3 = AppShortcut(key: "3", modifiers: [.command, .control])
  static let selectTab4 = AppShortcut(key: "4", modifiers: [.command, .control])
  static let selectTab5 = AppShortcut(key: "5", modifiers: [.command, .control])
  static let selectTab6 = AppShortcut(key: "6", modifiers: [.command, .control])
  static let selectTab7 = AppShortcut(key: "7", modifiers: [.command, .control])
  static let selectTab8 = AppShortcut(key: "8", modifiers: [.command, .control])
  static let selectTab9 = AppShortcut(key: "9", modifiers: [.command, .control])

  // Refresh
  static let refreshProjects = AppShortcut(key: "r", modifiers: [.command, .shift])

  /// All shortcuts that need to be unbound from ghostty so the app can handle them.
  static let all: [AppShortcut] = [
    newShellTab,
    newPiTab,
    closeTab,
    closeWindow,
    nextTab,
    previousTab,
    openLazygit,
    openLumenDiff,
    openInZed,
    toggleSidebar,
    focusSidebar,
    selectTab1,
    selectTab2,
    selectTab3,
    selectTab4,
    selectTab5,
    selectTab6,
    selectTab7,
    selectTab8,
    selectTab9,
    refreshProjects,
  ]
}
