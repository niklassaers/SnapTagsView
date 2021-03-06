import UIKit

open class SnapTagCell: UICollectionViewCell {

    weak var sizer : SnapTextWidthSizers?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!

    @IBOutlet weak var backgroundImageForOnState: UIImageView!
    @IBOutlet weak var backgroundImageForOffState: UIImageView!

    @IBOutlet weak var highlightBackground: UIView!

    @IBOutlet weak var onOffButton: UIView!
    @IBOutlet weak var onButtonImage: UIImageView!
    @IBOutlet weak var offButtonImage: UIImageView!

    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var spacingMargin: NSLayoutConstraint!

    @IBOutlet var onOffButtonDimensions: [NSLayoutConstraint]!

    internal var configuration : SnapTagButtonConfiguration!
    internal var lastText: String = "Snapsale"

    open func setOnState() {
        backgroundImageForOnState.alpha = 1.0
        backgroundImageForOffState.alpha = 0.0
        onButtonImage.alpha = 0.0
        offButtonImage.alpha = 1.0
        onOffButton.transform = configuration.onState.buttonTransform
        setTextColor(configuration.onState.textColor)

        highlightBackground.backgroundColor = configuration.highlightedWhileOnState.backgroundColor
        highlightBackground.layer.cornerRadius = configuration.highlightedWhileOnState.cornerRadius

        self.isSelected = true
    }

    open func setOffState() {
        backgroundImageForOnState.alpha = 0.0
        backgroundImageForOffState.alpha = 1.0
        onButtonImage.alpha = 1.0
        offButtonImage.alpha = 0.0
        onOffButton.transform = configuration.offState.buttonTransform
        setTextColor(configuration.offState.textColor)

        highlightBackground.backgroundColor = configuration.highlightedWhileOffState.backgroundColor
        highlightBackground.layer.cornerRadius = configuration.highlightedWhileOffState.cornerRadius

        self.isSelected = false
    }

    open func setHighlightState(_ enabled : Bool) {
        let onValue = configuration.isOn ?
            configuration.highlightedWhileOnState.alpha :
            configuration.highlightedWhileOffState.alpha

        self.highlightBackground.alpha = enabled ? onValue : 0.0
    }

    open func applyConfiguration(_ configuration: SnapTagButtonConfiguration) {
        self.configuration = configuration

        setupMargins()
        setupBackground()
        setupLabel()
        setupOnOffButton()

        if configuration.isOn {
            setOnState()
        } else {
            setOffState()
        }
        
//        trailingMargin.constant = 10
//        spacingMargin.constant = 6
    }

    open override var intrinsicContentSize : CGSize {
        return configuration.intrinsicContentSize
    }

    open func setTextColor(_ color: UIColor) {
        label.textColor = color
    }

    internal func setupBackground() {
        setBackgroundColor(onColor: configuration.onState.backgroundColor, offColor: configuration.offState.backgroundColor)
        setBackgroundImages(onImage: configuration.onState.backgroundImage, offImage: configuration.offState.backgroundImage)
        backgroundImageForOnState.layer.cornerRadius = configuration.onState.cornerRadius
        backgroundImageForOnState.layer.masksToBounds = true
        backgroundImageForOffState.layer.cornerRadius = configuration.offState.cornerRadius
        backgroundImageForOffState.layer.masksToBounds = true

        if let onBorderColor = configuration.onState.borderColor,
            let onBorderWidth = configuration.onState.borderWidth {
                backgroundImageForOnState.layer.borderColor = onBorderColor.cgColor
                backgroundImageForOnState.layer.borderWidth = onBorderWidth
        }

        if let offBorderColor = configuration.offState.borderColor,
            let offBorderWidth = configuration.offState.borderWidth {
                backgroundImageForOffState.layer.borderColor = offBorderColor.cgColor
                backgroundImageForOffState.layer.borderWidth = offBorderWidth
        }

    }

    internal func setupLabel() {
        setFont(configuration.font)
    }

    internal func setupOnOffButton() {
        if configuration.hasOnOffButton {
            enableOnOffButton()
        } else {
            disableOnOffButton()
        }
    }

    internal func setupMargins() {
        topMargin.constant = max(configuration.labelInset.top, configuration.buttonInset.top)
        bottomMargin.constant = max(configuration.labelInset.bottom, configuration.buttonInset.bottom)
        leadingMargin.constant = configuration.labelInset.left
        trailingMargin.constant = configuration.buttonInset.right
    }

    internal func disableOnOffButton() {
        for constraint in onOffButtonDimensions {
            constraint.constant = 0.0
        }
        spacingMargin.constant = 0.0
    }

    internal func enableOnOffButton() {
        for constraint in onOffButtonDimensions {
            constraint.constant = (configuration.onState.buttonImage?.size.height ?? 0.0) / 2.0
        }
        spacingMargin.constant = configuration.onState.spacingBetweenLabelAndOnOffButton
    }

    internal func setFont(_ font: UIFont) {
        label.font = font
        if label.text != "" {

            let size = sizeForLabel(label)
            labelWidth.constant = size.width
            labelHeight.constant = size.height
        }
    }

    internal func sizeForLabel(_ label: UILabel) -> CGSize {
        let size : CGSize
        if let sizer = sizer {
            size = sizer.calculateSizeForText(label.text ?? "", font: label.font)
        } else {
            size = label.sizeThatFits(CGSize(width: 2000, height: 100))
        }
        return size
    }

    internal func setText(_ text: String) {
        lastText = text.uppercased()
        label.text = text.uppercased()

        let size = sizeForLabel(label)
        labelWidth.constant = size.width
    }

    internal func setBackgroundImages(onImage: UIImage?, offImage: UIImage?) {
        backgroundImageForOnState.image = onImage
        backgroundImageForOffState.image = offImage
    }

    internal func setBackgroundColor(onColor: UIColor?, offColor: UIColor?) {
        backgroundImageForOnState.backgroundColor = onColor
        backgroundImageForOffState.backgroundColor = offColor
    }

    // And the classic bug-fix
    override open var bounds: CGRect {
        didSet {
            contentView.frame = bounds
            contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        }
    }

    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        let size: CGSize

        if let sizer = sizer {
            let calculatedSize = sizer.calculateSizeForTag(lastText, configuration: configuration)
            size = CGSize(width: round(calculatedSize.width), height: round(calculatedSize.height))
        } else {
            let intrinsicSize = configuration.intrinsicContentSize
            size = CGSize(width: round(intrinsicSize.width), height: round(intrinsicSize.height))
        }

        if size == layoutAttributes.frame.size {
            return layoutAttributes
        } else {

            let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes

            var frame = layoutAttributes.frame
            frame.size.height = size.height
            if abs(frame.size.width - size.width) > 2.0 { // Less is just not worth quarelling about
                frame.size.width = size.width
            }
            attr.frame = frame
            return attr
        }
    }
}
