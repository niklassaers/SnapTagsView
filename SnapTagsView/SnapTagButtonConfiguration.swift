import Foundation

public class SnapTagButtonConfiguration : NSObject {
    
    var font : UIFont!
    
    var backgroundImage : UIImage!
    
    var backgroundColor : UIColor!
    var textColor : UIColor!
    var selectedBackgroundColor : UIColor!
    var selectedTextColor : UIColor!
    
    var delegate: TagsButtonDelegate?
    
    var isTurnOnOffAble: Bool = false
    
    var horizontalMargin : CGFloat = 10.0
    var height : CGFloat = 44.0
    var cornerRadius : CGFloat = 5.0
    
    var onOffButtonImage : UIImage!
    
    override init() {
        super.init()
    }
    
    convenience init(viewConfig: SnapTagsViewConfiguration) {
        self.init()
        
        horizontalMargin = viewConfig.horizontalMargin
        height = viewConfig.height
    }
    
    func isValid() -> Bool {
        var test = true
        
        test = test && font != nil
        test = test && backgroundColor != nil
        test = test && textColor != nil
        test = test && selectedBackgroundColor != nil
        test = test && selectedTextColor != nil
        test = test && onOffButtonImage != nil
        
        return test
    }
    
    public static func defaultConfiguration() -> SnapTagButtonConfiguration {
        let c = SnapTagButtonConfiguration()
        
        c.onOffButtonImage = UIImage.Asset.YellowCloseButton.image
        c.backgroundImage = UIImage.Asset.RoundedButton.image
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

