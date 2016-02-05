import Foundation

public struct ButtonStateConfiguration {

    public var textColor : UIColor = UIColor.blackColor()
    public var backgroundImage : UIImage? = nil
    public var backgroundColor : UIColor = UIColor.grayColor()
    public var cornerRadius : CGFloat = 5.0
    public var borderColor : UIColor? = UIColor.blackColor()
    public var borderWidth : CGFloat? = 0.0

    public var spacingBetweenLabelAndOnOffButton : CGFloat = 0.0

    public var hasButton : Bool = false
    public var buttonImage : UIImage? = nil
    public var buttonTransform : CGAffineTransform = CGAffineTransformIdentity

    public var alpha : CGFloat = 1.0

    public init() {

    }
}
