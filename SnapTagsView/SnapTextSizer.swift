import Foundation

public class SnapTextWidthSizers {

    internal var nonPurgingCache = [String: CGSize]()

    public init() { }

    public func calculateSizeFor(string: String, font: UIFont) -> CGSize {

        let key = "\(string)-\(font.fontName)-\(font.pointSize)"
        if let value = nonPurgingCache[key] {
            return value
        }

        let attrStr = NSMutableAttributedString(string:string)
        attrStr.addAttribute(NSFontAttributeName,
            value:font,
            range:NSMakeRange(0, string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        let size = attrStr.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: [], context: nil)

        nonPurgingCache[key] = size.size
        return size.size
    }
}
