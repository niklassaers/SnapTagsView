import Foundation

@objc protocol TagsButtonDelegate : class {
    func tagButtonTapped(tag: String)
    
    optional func tagButtonTurnedOn(tag: String)
    optional func tagButtonTurnedOff(tag: String)
}
