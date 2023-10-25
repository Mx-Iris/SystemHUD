import AppKit

class AlphaAnimation: NSAnimation {
    var alphaDidChange: (CGFloat) -> Void = { _ in }
    var startAlpha: CGFloat = 1.0
    var endAlpha: CGFloat = 0.0

    override var currentProgress: NSAnimation.Progress {
        didSet {
            let alphaValue = startAlpha + (endAlpha - startAlpha) * CGFloat(currentProgress)
            alphaDidChange(alphaValue)
        }
    }
}
