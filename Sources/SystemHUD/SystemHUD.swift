import AppKit

extension SystemHUD {
    public struct Configuration {
        public var image: NSImage?
        public var imageSpacing: CGFloat
        public var title: String
        public var titleFontSize: CGFloat
        public var titleFontWeight: NSFont.Weight
        public var titleColor: NSColor
        public var titleAlignment: NSTextAlignment
        public var offset: CGPoint
        public var dismissAnimateDuration: TimeInterval
        
        public init(image: NSImage? = nil, imageSpacing: CGFloat = 15, title: String, titleFontSize: CGFloat = 18, titleFontWeight: NSFont.Weight = .regular, titleColor: NSColor = .labelColor, titleAlignment: NSTextAlignment = .center, offset: CGPoint = .zero, dismissAnimateDuration: TimeInterval = 1.0) {
            self.image = image
            self.imageSpacing = imageSpacing
            self.title = title
            self.titleFontSize = titleFontSize
            self.titleFontWeight = titleFontWeight
            self.titleColor = titleColor
            self.titleAlignment = titleAlignment
            self.offset = offset
            self.dismissAnimateDuration = dismissAnimateDuration
        }
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
