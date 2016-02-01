import Foundation

public class SnapTagButtonConfiguration : NSObject {
    
    public var font : UIFont!
    
    public var onBackgroundImage : UIImage!
    public var offBackgroundImage : UIImage!
    
    public var backgroundColor : UIColor!
    public var textColor : UIColor!
    public var selectedBackgroundColor : UIColor!
    public var selectedTextColor : UIColor!
    
    public var delegate: TagsButtonDelegate?
    
    public var isTurnOnOffAble: Bool = false
    
    public var horizontalMargin : CGFloat = 10.0
    public var height : CGFloat = 44.0
    public var cornerRadius : CGFloat = 5.0
    
    public var onOffButtonImage : OnOffButtonConfiguration!
    
    public override init() {
        super.init()
        
        onOffButtonImage = OnOffButtonConfiguration()
    }
    
    public convenience init(viewConfig: SnapTagsViewConfiguration) {
        self.init()
        
        horizontalMargin = viewConfig.horizontalMargin
        height = viewConfig.height
    }
    
    public func isValid() -> Bool {
        var test = true
        
        test = test && font != nil
        test = test && backgroundColor != nil
        test = test && textColor != nil
        test = test && selectedBackgroundColor != nil
        test = test && selectedTextColor != nil
        test = test && onOffButtonImage != nil && onOffButtonImage.isValid()
        
        return test
    }
    
    public static func defaultConfiguration() -> SnapTagButtonConfiguration {
        let c = SnapTagButtonConfiguration()
        
        c.onOffButtonImage.onImage = UIImage.Asset.YellowCloseButton.image
        c.onOffButtonImage.offImage = UIImage.Asset.RedCloseButton.image
        
        c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        c.offBackgroundImage = UIImage.Asset.RoundedButton.image
        c.font = UIFont.boldSystemFontOfSize(13.0)
        c.backgroundColor = UIColor.roseColor()
        c.textColor = UIColor.whiteColor()
        c.selectedBackgroundColor = UIColor.whiteColor()
        c.selectedTextColor = UIColor.roseColor()
        c.isTurnOnOffAble = true
        
        assert(c.isValid())
        return c
    }

}

