import AppKit

extension SystemHUD {
    public struct Configuration {
        public var image: NSImage?
        public var imageSpacing: CGFloat = 15
        public var title: String
        public var titleFontSize: CGFloat = 18
        public var titleFontWeight: NSFont.Weight = .regular
        public var titleColor: NSColor = .labelColor
        public var titleAlignment: NSTextAlignment = .center
        public var offset: CGPoint = .zero
        public var dismissAnimateDuration: TimeInterval = 1.0
    }
}

public final class SystemHUD {
    public static let `default` = SystemHUD(configuration: .init(title: "Default"))

    public var configuration: Configuration {
        didSet {
            window.hudView.configuration = configuration
        }
    }

    private let window: SystemHUDWindow

    private var hideHUDTimer: Timer?

    private var animation: AlphaAnimation?

    public init(configuration: Configuration) {
        self.configuration = configuration
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
