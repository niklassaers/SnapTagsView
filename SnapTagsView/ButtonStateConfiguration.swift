import Foundation

public struct ButtonStateConfiguration {

    public var textColor : UIColor = UIColor.black
    public var backgroundImage : UIImage? = nil
    public var backgroundColor : UIColor = UIColor.gray
    public var cornerRadius : CGFloat = 5.0
    public var borderColor : UIColor? = UIColor.black
    public var borderWidth : CGFloat? = 0.0

    public var spacingBetweenLabelAndOnOffButton : CGFloat = 0.0

    public var hasButton : Bool = false
    public var buttonImage : UIImage? = nil
    public var buttonTransform : CGAffineTransform = CGAffineTransform.identity

    public var alpha : CGFloat = 1.0

    public init() {

    }
}
