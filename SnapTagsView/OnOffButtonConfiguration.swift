import Foundation

public class OnOffButtonConfiguration : NSObject {
    
    public var onImage : UIImage!
    public var onTransform : CGAffineTransform! = CGAffineTransformIdentity
    public var offImage : UIImage!
    public var offTransform : CGAffineTransform! = CGAffineTransformIdentity
    
    public func isValid() -> Bool {
        return onImage != nil &&
            onTransform != nil &&
            offImage != nil &&
            offTransform != nil &&
            onImage.size.height == offImage.size.height &&
            onImage.size.width == offImage.size.width
    }
}
