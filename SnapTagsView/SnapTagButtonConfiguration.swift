import Foundation

public struct SnapTagButtonConfiguration {

    public var isOn : Bool = true
    public var canBeTurnedOnAndOff: Bool = false
    public var isTappable : Bool = true

    public var font : UIFont! = UIFont.systemFont(ofSize: 13.0)

    public var onState = ButtonStateConfiguration()
    public var highlightedWhileOnState = ButtonStateConfiguration()
    public var offState = ButtonStateConfiguration()
    public var highlightedWhileOffState = ButtonStateConfiguration()


    public var intrinsicContentSize = CGSize(width: 30, height: 30)

    public var margin : UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    public var labelInset : UIEdgeInsets = UIEdgeInsets.zero
    public var buttonInset : UIEdgeInsets = UIEdgeInsets.zero

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
