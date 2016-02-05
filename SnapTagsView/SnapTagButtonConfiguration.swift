import Foundation

public struct SnapTagButtonConfiguration {

    public var isOn : Bool = true
    public var canBeTurnedOnAndOff: Bool = false
    public var isTappable : Bool = true

    public var font : UIFont! = UIFont.systemFontOfSize(13.0)

    public var onState = ButtonStateConfiguration()
    public var highlightedWhileOnState = ButtonStateConfiguration()
    public var offState = ButtonStateConfiguration()
    public var highlightedWhileOffState = ButtonStateConfiguration()


    public var horizontalMargin : CGFloat = 10.0
    public var verticalMargin : CGFloat = 10.0

    public var intrinsicContentSize = CGSizeMake(30, 30)

    public var labelVOffset : CGFloat = 0.0
    public var labelHOffset : CGFloat = 0.0

    public init() {

    }

    public var hasOnOffButton : Bool {
        get {
            if isOn {
                return onState.hasButton
            } else {
                return offState.hasButton
            }
        }
    }

}
