import AppKit

class SystemHUDView: NSView {
    let visualEffectView: NSVisualEffectView = .init()

    let imageView: NSImageView = .init()

    let textField: NSTextField = .init(labelWithString: "")

    var configuration: SystemHUD.Configuration {
        didSet {
            reloadConfiguration()
        }
    }

    init(configuration: SystemHUD.Configuration) {
        self.configuration = configuration
        let frameRect = NSRect(x: 0, y: 0, width: 200, height: 200)
        super.init(frame: frameRect)
        addSubview(visualEffectView)
        visualEffectView.frame = frameRect
        visualEffectView.addSubview(imageView)
        visualEffectView.addSubview(textField)
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 15

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor, constant: -10),
        ])

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            textField.leftAnchor.constraint(lessThanOrEqualTo: visualEffectView.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(lessThanOrEqualTo: visualEffectView.rightAnchor, constant: -10),
        ])

        reloadConfiguration()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadConfiguration() {
        textField.stringValue = configuration.title
        textField.textColor = configuration.titleColor
        textField.font = .systemFont(ofSize: configuration.titleFontSize, weight: configuration.titleFontWeight)
        textField.alignment = configuration.titleAlignment
        imageView.image = configuration.image
    }
}
