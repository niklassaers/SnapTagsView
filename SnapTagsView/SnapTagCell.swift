import UIKit

public class SnapTagCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundImageForOnState: UIImageView!
    @IBOutlet weak var backgroundImageForOffState: UIImageView!
    
    @IBOutlet weak var onOffButton: UIView!
    @IBOutlet weak var onButtonImage: UIImageView!
    @IBOutlet weak var offButtonImage: UIImageView!
    
    @IBOutlet var verticalMargins: [NSLayoutConstraint]!
    @IBOutlet var horizontalMargins: [NSLayoutConstraint]!
    @IBOutlet weak var spacingMargin: NSLayoutConstraint!
    
    @IBOutlet var onOffButtonDimensions: [NSLayoutConstraint]!
    
    internal var configuration : SnapTagButtonConfiguration!
    internal var lastText: String = "Snapsale"
    
    public func setOnState() {
        backgroundImageForOnState.alpha = 1.0
        backgroundImageForOffState.alpha = 0.0
        onButtonImage.alpha = 0.0
        offButtonImage.alpha = 1.0
        onOffButton.transform = configuration.onOffButtonImage.onTransform
        setTextColor(configuration.onTextColor)
    }
    
    public func setOffState() {
        backgroundImageForOnState.alpha = 0.0
        backgroundImageForOffState.alpha = 1.0
        onButtonImage.alpha = 1.0
        offButtonImage.alpha = 0.0
        onOffButton.transform = configuration.onOffButtonImage.offTransform
        setTextColor(configuration.offTextColor)
    }
    
    public func applyConfiguration(configuration: SnapTagButtonConfiguration) {
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
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return configuration.intrinsicContentSize
    }
    
    public func setTextColor(color: UIColor) {
        label.textColor = color
    }
    
    internal func setupBackground() {
        setBackgroundColor(onColor: configuration.onBackgroundColor, offColor: configuration.offBackgroundColor)
        setBackgroundImages(onImage: configuration.onBackgroundImage, offImage: configuration.offBackgroundImage)
        self.layer.cornerRadius = configuration.cornerRadius
        self.layer.masksToBounds = true
    }
    
    internal func setupLabel() {
        setFont(configuration.font)
    }
    
    internal func setupOnOffButton() {
        if configuration.isTurnOnOffAble {
            enableOnOffButton()
        } else {
            disableOnOffButton()
        }
    }
    
    internal func setupMargins() {
        for margin in horizontalMargins {
            margin.constant = configuration.horizontalMargin
        }
        
        for margin in verticalMargins {
            margin.constant = configuration.verticalMargin
        }
    }
    
    internal func disableOnOffButton() {
        for constraint in onOffButtonDimensions {
            constraint.constant = 0.0
        }
        spacingMargin.constant = 0.0
    }
    
    internal func enableOnOffButton() {
        for constraint in onOffButtonDimensions {
            constraint.constant = configuration.onOffButtonImage.onImage.size.height / 2.0
        }
        spacingMargin.constant = configuration.spacingBetweenLabelAndOnOffButton
    }
    
    internal func setFont(font: UIFont) {
        label.font = font
        if label.text != "" {
            let size = label.sizeThatFits(CGSizeMake(2000, 100))
            labelWidth.constant = size.width
        }
    }
    
    internal func setText(text: String) {
        lastText = text
        label.text = text.uppercaseString
        let size = label.sizeThatFits(CGSizeMake(2000, 100))
        labelWidth.constant = size.width
    }
    
    internal func setBackgroundImages(onImage onImage: UIImage, offImage: UIImage) {
        backgroundImageForOnState.image = onImage
        backgroundImageForOffState.image = offImage
    }
    
    internal func setBackgroundColor(onColor onColor: UIColor, offColor: UIColor) {
        backgroundImageForOnState.backgroundColor = onColor
        backgroundImageForOffState.backgroundColor = offColor
    }
    
    // And the classic bug-fix
    override public var bounds: CGRect {
        didSet {
            contentView.frame = bounds
            contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        }
    }
    
    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        var label : UILabel! = self.label
        if label == nil {
            label = UILabel(frame: CGRectZero)
            label.text = lastText
            label.font = configuration.font
        }
        
        let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        var newFrame = attr.frame
        self.frame = attr.frame
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let size = label.sizeThatFits(CGSizeMake(2000, 100))
        var width = configuration.horizontalMargin * 2 + size.width
        if configuration.isTurnOnOffAble {
            width += configuration.spacingBetweenLabelAndOnOffButton + configuration.onOffButtonImage.onImage.size.height / 2.0
        }
        newFrame.size = CGSizeMake(width, size.height + (2 * configuration.verticalMargin))
        attr.frame = newFrame
        return attr
    }
}
