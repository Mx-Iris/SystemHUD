import AppKit

class SystemHUDWindow: NSWindow {
    let hudView: SystemHUDView

    init(configuration: SystemHUD.Configuration) {
        self.hudView = .init(configuration: configuration)
        super.init(contentRect: .init(x: 0, y: 0, width: 200, height: 200), styleMask: [.borderless], backing: .buffered, defer: false)

        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = .clear
        self.level = .floating
        self.contentView = hudView
    }
}
