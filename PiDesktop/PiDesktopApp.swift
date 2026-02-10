import AppKit
import GhosttyKit
import SwiftUI

@main
@MainActor
struct PiDesktopApp: App {
  @State private var ghostty: GhosttyRuntime
  @State private var surfaceView: GhosttySurfaceView

  @MainActor init() {
    NSWindow.allowsAutomaticWindowTabbing = false

    // Point ghostty at bundled resources
    if let resourceURL = Bundle.main.resourceURL?.appendingPathComponent("ghostty") {
      setenv("GHOSTTY_RESOURCES_DIR", resourceURL.path, 1)
    }

    // Initialize ghostty with no extra CLI args (just the executable name)
    let argv: [UnsafeMutablePointer<CChar>?] = [strdup(CommandLine.arguments.first ?? "PiDesktop"), nil]
    argv.withUnsafeBufferPointer { buffer in
      let argc = UInt(max(0, buffer.count - 1))
      let ptr = UnsafeMutablePointer(mutating: buffer.baseAddress)
      if ghostty_init(argc, ptr) != GHOSTTY_SUCCESS {
        preconditionFailure("ghostty_init failed")
      }
    }

    let runtime = GhosttyRuntime()
    _ghostty = State(initialValue: runtime)

    // Create a surface that runs the user's default shell in the home directory
    let homeURL = FileManager.default.homeDirectoryForCurrentUser
    let surface = GhosttySurfaceView(runtime: runtime, workingDirectory: homeURL)

    // Handle close request: when the shell exits, quit the app
    surface.bridge.onCloseRequest = { _ in
      NSApp.terminate(nil)
    }

    _surfaceView = State(initialValue: surface)
  }

  var body: some Scene {
    Window("PiDesktop", id: "main") {
      GhosttyColorSchemeSyncView(ghostty: ghostty) {
        GhosttyTerminalView(surfaceView: surfaceView)
      }
    }
  }
}

private struct GhosttyColorSchemeSyncView<Content: View>: View {
  @Environment(\.colorScheme) private var colorScheme
  let ghostty: GhosttyRuntime
  let content: Content

  init(ghostty: GhosttyRuntime, @ViewBuilder content: () -> Content) {
    self.ghostty = ghostty
    self.content = content()
  }

  var body: some View {
    content
      .task {
        apply(colorScheme)
      }
      .onChange(of: colorScheme) { _, newValue in
        apply(newValue)
      }
  }

  private func apply(_ scheme: ColorScheme) {
    ghostty.setColorScheme(scheme)
  }
}
