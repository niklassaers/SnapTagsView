import Foundation

public class SnapTagsViewConfiguration : NSObject {
    
    public var spacing = 5.0 as CGFloat
    public var horizontalMargin = 5.0 as CGFloat
    public var verticalMargin = 5.0 as CGFloat
    public var height = 30.0 as CGFloat
    
    var alignment : NSTextAlignment = .Left
    
    func isValid() -> Bool {
        return true
    }
    
    public static func defaultConfiguration() -> SnapTagsViewConfiguration {
        return SnapTagsViewConfiguration()
    }
    
}

