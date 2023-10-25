import AppKit

public final class SystemHUD {
    public struct Configuration {
        public var image: NSImage?
        public var title: String
        public var titleFontSize: CGFloat = 18
        public var titleFontWeight: NSFont.Weight = .regular
        public var titleColor: NSColor = .labelColor
        public var titleAlignment: NSTextAlignment = .center
        public var dismissAnimateDuration: TimeInterval = 1.0
    }

    public static let shared = SystemHUD()
    
    public var configuration: Configuration = .init(title: "This is a HUD") {
        didSet {
            window.hudView.configuration = configuration
        }
    }

    private let window: SystemHUDWindow

    private var hideHUDTimer: Timer?

    private var animation: AlphaAnimation?

    private init() {
        self.window = SystemHUDWindow(configuration: configuration)
        positionHUD()
    }

    private func positionHUD() {
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let hudPosition = CGPoint(
                x: screenFrame.midX - window.frame.width / 2,
                y: screenFrame.midY - screenFrame.size.height * 0.38 - window.frame.height / 2
            )
            print(hudPosition)
            window.setFrameOrigin(hudPosition)
        }
    }

    private func fadeOut(duration: TimeInterval) {
        let animation = AlphaAnimation(duration: duration, animationCurve: .easeIn)
        animation.alphaDidChange = { [weak self] alphaValue in
            guard let self else { return }
            window.alphaValue = alphaValue
        }
        animation.startAlpha = window.alphaValue
        animation.endAlpha = 0.0
        animation.animationBlockingMode = .nonblocking
        animation.start()
        self.animation = animation
    }

    public func show(delay: TimeInterval) {
        animation?.stop()
        animation = nil
        window.alphaValue = 1
        window.orderFront(nil)

        hideHUDTimer?.invalidate()
        hideHUDTimer = nil
        hideHUDTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            guard let self else { return }
            fadeOut(duration: configuration.dismissAnimateDuration)
            hideHUDTimer = nil
        }
    }
}
