import Foundation

public protocol SnapTagsButtonDelegate : class {
    func snapTagButtonTapped(tag: SnapTagRepresentation, sender: SnapTagsCollectionViewController)

    func snapTagButtonTurnedOn(tag: String)
    func snapTagButtonTurnedOff(tag: String)
}
