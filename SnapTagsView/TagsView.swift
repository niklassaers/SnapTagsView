import UIKit
import OAStackView
import NSLayoutConstraint_ExpressionFormat

public class TagsView: UIView {

    var config : SnapTagsViewConfiguration!
    var systemDelegate : SystemDelegate?
    
    var delegate: TagsButtonDelegate?
//
//
//
//
//    var boundsForDeterminingWidth : CGRect?

//
    
//    public lazy var tagBackgroundColor = UIColor.roseColor()
//    public lazy var tagTextColor = UIColor.whiteColor()
//    public lazy var onOffButtonImage = UIImage.Asset.Icon_s_close_yellow.image

//    public lazy var defaultSelectedBackgroundColor = UIColor.whiteColor()
//    public lazy var defaultSelectedTextColor = UIColor.roseColor()

    var backgroundImagesForState : [UInt : UIImage] = [:]
    
    var verticalStackView : OAStackView?
    
    public func setBackgroundImage(image: UIImage, forState state: UIControlState) {
        self.backgroundImagesForState[state.rawValue] = image
    }

    internal func createVerticalStackView() -> OAStackView {
        
        let stack = OAStackView()
        self.addSubview(stack)
        stack.axis = .Vertical
        stack.alignment = .Center
        stack.spacing = config.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let hConstraints = "H:|-(hMargin)-[stack]-(hMargin)-|"
        let vConstraints = "V:|-(vMargin)-[stack]-(vMargin)-|"
        let metrics = ["hMargin": config.horizontalMargin, "vMargin": config.verticalMargin]
        let views = ["stack": stack]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hConstraints, options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vConstraints, options: [], metrics: metrics, views: views))

        return stack
    }
    
    internal func createHorizontalStackView() -> OAStackView {
        
        let stack = OAStackView()
        stack.axis = .Horizontal
        stack.spacing = config.spacing
        
        
        if config.alignment == .Center {
            stack.alignment = .Center
            stack.distribution = .EqualCentering
        } else if config.alignment == .Left {
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        if config.alignment == .Center || config.alignment == .Right {
            stack.addArrangedSubview(spacerView())
        }

        return stack
    }
    
    internal func spacerView() -> UIView {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        view.setContentHuggingPriority(1.0, forAxis: .Horizontal)
        view.setContentCompressionResistancePriority(1.0, forAxis: .Horizontal)
        return view
    }
    
    internal func terminateHorizontalStackView(stack: OAStackView) {
        if config.alignment == .Center {
            let lastSpacer = self.spacerView()
            stack.addArrangedSubview(lastSpacer)
            
            let firstSpacer = stack.arrangedSubviews.first!
            stack.addConstraint(NSLayoutConstraint(expressionFormat: "lastSpacer.width = firstSpacer.width", parameters: ["firstSpacer": firstSpacer, "lastSpacer": lastSpacer]))
            
        } else if config.alignment == .Left {
            guard let firstButton = stack.arrangedSubviews.first else {
                return
            }
            
            let lastSpacer = self.spacerView()
            stack.addArrangedSubview(lastSpacer)
            let widthConstraint = NSLayoutConstraint(expressionFormat: "lastSpacer.width = 300", parameters: ["lastSpacer": lastSpacer])
            widthConstraint.priority = 30
            lastSpacer.addConstraint(widthConstraint)
            stack.addConstraint(NSLayoutConstraint(expressionFormat: "lastSpacer.height = firstButton.height", parameters: ["firstButton": firstButton, "lastSpacer": lastSpacer]))

        }
    }
    
    public func populateTagViewWithTagsAndDetermineHeight(tags: [String], turnOnOffAble: Bool = false, horizontalMargin:CGFloat = 10.0) -> CGSize {
        
        self.userInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.verticalStackView = createVerticalStackView()
        
        var currentPosition = CGPointMake(config.horizontalMargin, config.verticalMargin)
        var lastButton : TagsButton?
        var boundsForDeterminingWidth : CGRect! = self.boundsForDeterminingWidth
        if boundsForDeterminingWidth == nil {
            boundsForDeterminingWidth = self.superview?.bounds
        }
        
        if boundsForDeterminingWidth == nil {
            self.systemDelegate?.logError("TagsView: Could not get tagsview parent view. This is bad!")
            return CGSizeMake(0, 40.0)
        }
        
        self.bounds.size = CGSizeMake(boundsForDeterminingWidth.size.width, CGFloat(FLT_MAX))
        
        var hStack = createHorizontalStackView()
        
        for tag in tags {
            let button = TagsButton(
                tag: tag,
                turnOnOffAble: turnOnOffAble,
                height: config.height,
                horizontalMargin: horizontalMargin,
                onOffButtonImage: self.onOffButtonImage,
                backgroundColor: self.tagBackgroundColor,
                textColor: self.tagTextColor,
                selectedBackgroundColor: self.defaultSelectedBackgroundColor,
                selectedTextColor: self.defaultSelectedTextColor
            )
            //button.translatesAutoresizingMaskIntoConstraints = false
            
            for (state, image) in self.backgroundImagesForState {
                switch(state) {
                case UIControlState.Normal.rawValue:
                    button.setBackgroundImage(image, forState: UIControlState.Normal)
                case UIControlState.Selected.rawValue:
                    button.setBackgroundImage(image, forState: UIControlState.Selected)
                case UIControlState.Highlighted.rawValue:
                    button.setBackgroundImage(image, forState: UIControlState.Highlighted)
                case UIControlState.Disabled.rawValue:
                    button.setBackgroundImage(image, forState: UIControlState.Disabled)
                default:
                    continue
                }
            }
            
            button.setTagBackgroundColor(self.tagBackgroundColor)
            button.setTagTextColor(self.tagTextColor)
            button.delegate = self
            button.userInteractionEnabled = true
            
            button.addConstraint(NSLayoutConstraint(expressionFormat: "button.height = \(button.frame.size.height)", parameters: ["button": button]))
            button.addConstraint(NSLayoutConstraint(expressionFormat: "button.width = \(button.frame.size.width)", parameters: ["button": button]))

            button.frame.origin = currentPosition
            let intersection = self.bounds.intersect(button.frame)
            if intersection == button.frame { // yes, there is space available for it
                button.frame.origin = CGPointZero
                hStack.addArrangedSubview(button)
                
                currentPosition.x += button.frame.size.width + self.defaultSpacing

            } else {
                button.frame.origin = CGPointZero
                self.terminateHorizontalStackView(hStack)
                self.verticalStackView?.addArrangedSubview(hStack)
                hStack = createHorizontalStackView()
                hStack.addArrangedSubview(button)

                currentPosition = CGPointMake(self.defaultHorizontalMargin, currentPosition.y + button.frame.size.height + self.defaultVerticalMargin)
                currentPosition.x += button.frame.size.width + self.defaultSpacing
            }
            lastButton = button
        }

        self.terminateHorizontalStackView(hStack)
        self.verticalStackView?.addArrangedSubview(hStack)

        if let lastButton = lastButton {
            self.bounds.size = CGSizeMake(self.bounds.size.width, currentPosition.y + lastButton.frame.size.height + self.defaultHorizontalMargin)
            self.setNeedsLayout()
            self.layoutIfNeeded()
            return CGSizeMake(currentPosition.x - self.defaultSpacing ,  self.bounds.size.height)
        } else {
            return CGSizeMake(0, 40.0)
        }
    }
    
    public func buttonsForTag(tag: String) -> [TagsButton] {
        
        return self.subviews.filter({ (view) -> Bool in
            if let button = view as? TagsButton {
                if button.title == tag {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }) as! [TagsButton]
        
    }
}

extension TagsView : TagsButtonDelegate {
    
    func tagButtonTapped(tag: String) {
        self.delegate?.tagButtonTapped(tag)
    }
    
    func tagButtonTurnedOn(tag: String) {
        self.delegate?.tagButtonTurnedOn?(tag)
    }
    
    func tagButtonTurnedOff(tag: String) {
        self.delegate?.tagButtonTurnedOff?(tag)
    }

}