import UIKit

public class TagsBarButton: UIView {

    var text: String?
    
    var selectButton: UIButton?
    
    var delegate: TagsBarButtonDelegate?
    
    public convenience init (tag: String) {
        self.init(frame: CGRectMake(0.0, 0.0, 100.0, 44.0))
        self.text = tag
        self.commonInit()
    }
    
    private func commonInit() {
        self.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleRightMargin]
        self.clipsToBounds = true
        
        self.selectButton = UIButton(type: UIButtonType.Custom)
        
        self.addSubview(self.selectButton!)
        
        let margin: CGFloat = 5.0
        
        self.selectButton?.titleLabel?.font = Theme.fontCustomMediumSize(13)
        self.selectButton?.setTitle(self.text!.uppercaseString, forState: UIControlState.Normal)
        self.selectButton?.backgroundColor = UIColor.roseColor()
        self.selectButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        self.selectButton?.sizeToFit()
        let textWidth = self.selectButton!.frame.size.width
        
        var frame = self.frame
        frame.size.width = textWidth + margin + margin

        self.frame = frame
        
        self.selectButton?.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        self.selectButton?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.selectButton?.addTarget(self, action: "selectAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //yellow line
        let underline = UIView(frame: CGRectMake(margin, (frame.size.height/2.0) + 12.0, textWidth, 1.5))
        underline.backgroundColor = Theme.getThemeYellowColor()
        self.addSubview(underline)
    }

    @IBAction func selectAction(sender: AnyObject?) {
        self.delegate?.tagBarButton(self.text!)
    }

}
