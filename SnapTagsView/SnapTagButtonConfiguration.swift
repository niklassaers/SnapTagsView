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
    
    static func defaultConfiguration() -> SnapTagButtonConfiguration {
        let c = SnapTagButtonConfiguration()
        
        return c
    }

}

/*
func defaultConfiguration() -> SnapTagsConfiguration {
backgroundImage = UIImage.Asset.RoundedButton.image
    font = Theme.fontCustomMediumSize(13)
    let conf = SnapTagsConfiguration
    conf.onOffButtonImage = UIImage.Asset.Icon_s_close_yellow.image
    
    var defaultBackgroundColor = UIColor.roseColor()
    var defaultSelectedBackgroundColor = UIColor.whiteColor()
    var defaultTextColor = UIColor.whiteColor()
    var defaultSelectedTextColor = UIColor.roseColor()

    turnOnOffAble: Bool = false,
    height: CGFloat = 44.0,
    horizontalMargin: CGFloat = 10.0,
    onOffButtonImage: UIImage,,
    backgroundColor: UIColor = UIColor.roseColor(),
    textColor: UIColor = UIColor.whiteColor(),
    selectedBackgroundColor: UIColor = UIColor.whiteColor(),
    selectedTextColor: UIColor = UIColor.roseColor()) {

    assert(conf.isValid())
    
    
}
*/
