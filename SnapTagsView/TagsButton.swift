import UIKit

@objc protocol TagsButtonDelegate : class {
    func tagButtonTapped(tag: String)
    
    optional func tagButtonTurnedOn(tag: String)
    optional func tagButtonTurnedOff(tag: String)
}

extension UIColor {
    static func roseColor() -> UIColor {
        return UIColor(red: 1.0, green: 0.0, blue: 88.0/255.0, alpha: 1.0)
    }
}

public class TagsButton: UIView {
    
    var title: String?
    
    var selectButton: UIButton?
    var onOffButton: UIButton?
    
    var delegate: TagsButtonDelegate?
    
    public var turnOnOffAble: Bool?
    
    var defaultHorizontalMargin = 10.0 as CGFloat
    
    lazy var defaultBackgroundColor = UIColor.roseColor()
    lazy var defaultSelectedBackgroundColor = UIColor.whiteColor()
    lazy var defaultTextColor = UIColor.whiteColor()
    lazy var defaultSelectedTextColor = UIColor.roseColor()
    
    internal var isSelected : Bool = true
    
    var onOffButtonImage : UIImage?
    
    public convenience init (
        tag: String,
        turnOnOffAble: Bool = false,
        height: CGFloat = 44.0,
        horizontalMargin: CGFloat = 10.0,
        onOffButtonImage: UIImage = UIImage.Asset.Icon_s_close_yellow.image,
        backgroundColor: UIColor = UIColor.roseColor(),
        textColor: UIColor = UIColor.whiteColor(),
        selectedBackgroundColor: UIColor = UIColor.whiteColor(),
        selectedTextColor: UIColor = UIColor.roseColor()) {

            self.init(frame: CGRectMake(0.0, 0.0, 100.0, height))
            self.title = tag
            self.turnOnOffAble = turnOnOffAble
            self.defaultHorizontalMargin = horizontalMargin
            self.onOffButtonImage = onOffButtonImage
            self.defaultBackgroundColor = backgroundColor
            self.defaultTextColor = textColor
            self.defaultSelectedBackgroundColor = selectedBackgroundColor
            self.defaultSelectedTextColor = selectedTextColor
            
            self.commonInit()
    }
    
    func setTagBackgroundColor(color: UIColor) {
        self.selectButton?.backgroundColor = color
    }
    
    func setTagTextColor(color: UIColor) {
        self.selectButton?.setTitleColor(color, forState: .Normal)
    }
    
    func setBackgroundImage(image: UIImage, forState state: UIControlState) {
        self.selectButton?.setBackgroundImage(image, forState: state)
    }
    
    private func commonInit() {
        self.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleRightMargin]
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        
        self.selectButton = UIButton(type: UIButtonType.Custom)
        
        self.addSubview(self.selectButton!)
        
        self.layer.cornerRadius = 5.0
        
        let margin = self.defaultHorizontalMargin
        
        self.selectButton?.titleLabel?.font = Theme.fontCustomMediumSize(13)
        self.selectButton?.setTitle(self.title!.uppercaseString, forState: UIControlState.Normal)
        self.selectButton?.backgroundColor = self.defaultBackgroundColor
        self.selectButton?.setTitleColor(self.defaultTextColor, forState: UIControlState.Normal)
        
        self.selectButton?.sizeToFit()
        let textWidth = self.selectButton!.frame.size.width
        
        var frame = self.frame
        frame.size.width = textWidth + margin + margin
        
        self.frame = frame
        
        self.selectButton?.enabled = true
        self.selectButton?.userInteractionEnabled = true
        self.selectButton?.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        self.selectButton?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.selectButton?.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if let turnOnOffAble = self.turnOnOffAble {
            if turnOnOffAble {
                self.setupOnOffButton()
            }
        }
    }

    func setupOnOffButton() {
        guard let selectButton = self.selectButton else {
            return
        }
        
        let onOffButtonSize = 24.0 as CGFloat
        
        selectButton.contentHorizontalAlignment = .Left
        selectButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        
        let size = floor(floor(((selectButton.titleLabel?.font.pointSize ?? (9.0/0.7)) * 0.7) + 1.0) / 2.0) * 2.0
        let onOffButton = UIButton(frame: CGRectMake(0, 0, size, size))
        onOffButton.setImage(self.onOffButtonImage, forState: .Normal)
        
        onOffButton.addTarget(self, action: "onOffButtonAction:", forControlEvents: .TouchUpInside)
        
        var frame = selectButton.frame
        frame.size.width += (size * 2)
        selectButton.frame = frame
        
        frame = onOffButton.frame
        frame.origin.y = floor((selectButton.frame.size.height - onOffButtonSize) / 2.0)
        frame.origin.x = floor(selectButton.frame.size.width - (0.85 * onOffButtonSize))
        frame.size.width = onOffButtonSize
        frame.size.height = onOffButtonSize
        onOffButton.frame = frame
        
        selectButton.addSubview(onOffButton)
        
        self.onOffButton = onOffButton
        
        frame = self.frame
        frame.size.width = frame.width + (1 * onOffButton.bounds.size.width)
        self.frame = frame
    }
    
    public func selected() -> Bool {
        return self.isSelected // self.selectButton?.selected ?? true
    }
    
    public func setSelected(selected: Bool) {
        self.isSelected = selected
        // self.selectButton?.selected = selected
        if selected {
            self.selectButton?.backgroundColor = self.defaultSelectedBackgroundColor
            self.selectButton?.setBackgroundImage(nil, forState: .Normal)
            self.selectButton?.setTitleColor(self.defaultSelectedTextColor, forState: UIControlState.Normal)
        } else {
            self.selectButton?.backgroundColor = self.defaultBackgroundColor
            self.selectButton?.setBackgroundImage(UIImage.Asset.RoundedButton.image, forState: .Normal)
            self.selectButton?.setTitleColor(self.defaultTextColor, forState: UIControlState.Normal)
        }
    }

    func selectAction(sender: AnyObject?) {
        self.delegate?.tagButtonTapped(self.title ?? "")
    }
    
    func onOffButtonAction(sender: UIButton) {
        if let delegate = self.delegate {
            if self.selected() {
                delegate.tagButtonTurnedOff?(self.title ?? "")
            } else {
                delegate.tagButtonTurnedOn?(self.title ?? "")
            }
        }
    }
    
}
