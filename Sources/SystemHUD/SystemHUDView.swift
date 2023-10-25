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

    var textFieldTopConstraint: NSLayoutConstraint!

    let contentLayoutGuide = NSLayoutGuide()

    var contentHeightConstraint: NSLayoutConstraint!
    var contentXConstraint: NSLayoutConstraint!
    var contentYConstraint: NSLayoutConstraint!
    
    var contentHeight: CGFloat {
        (configuration.image?.size.height ?? 0) + configuration.imageSpacing + textField.intrinsicContentSize.height
    }

    init(configuration: SystemHUD.Configuration) {
        self.configuration = configuration
        let frameRect = NSRect(x: 0, y: 0, width: 200, height: 200)
        super.init(frame: frameRect)
        addSubview(visualEffectView)

        visualEffectView.frame = frameRect
        visualEffectView.addLayoutGuide(contentLayoutGuide)
        visualEffectView.addSubview(imageView)
        visualEffectView.addSubview(textField)
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 15

        imageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
        ])

        self.textFieldTopConstraint = textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: configuration.imageSpacing)
        NSLayoutConstraint.activate([
            textFieldTopConstraint,
            textField.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            textField.leftAnchor.constraint(lessThanOrEqualTo: contentLayoutGuide.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(lessThanOrEqualTo: contentLayoutGuide.rightAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
        ])

        self.contentHeightConstraint = contentLayoutGuide.heightAnchor.constraint(equalToConstant: contentHeight)
        self.contentXConstraint = contentLayoutGuide.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor, constant: configuration.offset.x)
        self.contentYConstraint = contentLayoutGuide.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor, constant: configuration.offset.y)
        NSLayoutConstraint.activate([
            contentXConstraint,
            contentYConstraint,
            contentHeightConstraint,
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
        contentHeightConstraint.constant = contentHeight
        contentXConstraint.constant = configuration.offset.x
        contentYConstraint.constant = configuration.offset.y
        textFieldTopConstraint.constant = configuration.imageSpacing
        needsLayout = true
    }
}
