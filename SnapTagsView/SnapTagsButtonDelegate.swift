import Foundation

@objc public protocol SnapTagsButtonDelegate : class {
    func snapTagButtonTapped(_ tag: SnapTagRepresentation, sender: SnapTagsCollectionViewController)

    @objc optional func snapTagButtonTurnedOn(_ tag: String)
    @objc optional func snapTagButtonTurnedOff(_ tag: String)
    @objc optional func tappedOutsideTagButtons()
    @objc optional func searchTextChanged(_ text: String)
    @objc optional func searchCompletedWithString(_ text: String)
}
