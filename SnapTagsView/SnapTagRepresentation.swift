import Foundation

public class SnapTagRepresentation : NSObject {
    public var tag : String = ""
    public var isOn : Bool = true
    
    public override init() {
        
    }
    
    public init(tag: String, isOn: Bool = true) {
        self.tag = tag
        self.isOn = isOn
    }
}
