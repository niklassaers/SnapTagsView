import Foundation

@objc public protocol SnapTagsButtonDelegate : class {
    func snapTagButtonTapped(tag: SnapTagRepresentation)

    optional func snapTagButtonTurnedOn(tag: String)
    optional func snapTagButtonTurnedOff(tag: String)
}
