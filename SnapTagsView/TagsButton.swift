import UIKit

public class TagsButton: UIView {
    
    var config : SnapTagButtonConfiguration!
    
    var title: String?
    
    var selectButton: UIButton?
    var onOffButton: UIButton?
    
    internal var isSelected : Bool = true
    
    var onOffButtonImage : UIImage?
    
    public convenience init (
        tag: String,
        config: SnapTagButtonConfiguration) {

            self.init(frame: CGRectMake(0.0, 0.0, 100.0, config.height))

            self.config = config
            self.title = tag

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
        
        self.layer.cornerRadius = config.cornerRadius
        
        let margin = config.horizontalMargin
        
        self.selectButton?.titleLabel?.font = config.font
        self.selectButton?.setTitle(self.title!.uppercaseString, forState: UIControlState.Normal)
        self.selectButton?.backgroundColor = config.backgroundColor
        self.selectButton?.setTitleColor(config.textColor, forState: UIControlState.Normal)
        
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
        
        if  config.hasOnOffButton {
            self.setupOnOffButton()
        }
    }

    func setupOnOffButton() {
        guard let selectButton = self.selectButton else {
            return
        }
        
        let onOffButtonSize = config.onOffButtonImage.onImage.size.height
        
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
            self.selectButton?.backgroundColor = config.selectedBackgroundColor
            self.selectButton?.setBackgroundImage(nil, forState: .Normal)
            self.selectButton?.setTitleColor(config.selectedTextColor, forState: UIControlState.Normal)
        } else {
            self.selectButton?.backgroundColor = config.backgroundColor
            self.selectButton?.setBackgroundImage(config.offBackgroundImage, forState: .Normal)
            self.selectButton?.setTitleColor(config.textColor, forState: UIControlState.Normal)
        }
    }

    func selectAction(sender: AnyObject?) {
        config.delegate?.tagButtonTapped(self.title ?? "")
    }
    
    func onOffButtonAction(sender: UIButton) {
        if let delegate = config.delegate {
            if self.selected() {
                delegate.tagButtonTurnedOff?(self.title ?? "")
            } else {
                delegate.tagButtonTurnedOn?(self.title ?? "")
            }
        }
    }
    
}
