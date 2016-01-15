import Foundation

public class SnapTagsViewConfiguration : NSObject {
    
    var spacing = 5.0 as CGFloat
    var horizontalMargin = 5.0 as CGFloat
    var verticalMargin = 5.0 as CGFloat
    var height = 30.0 as CGFloat
    
    var alignment : NSTextAlignment = .Left
    
    func isValid() -> Bool {
        var test = true
        
        
        return test
    }
    
    static func defaultConfiguration() -> SnapTagsViewConfiguration {
        return SnapTagsViewConfiguration()
    }
    
}

protocol SystemDelegate {
    func logError(message: String)
}