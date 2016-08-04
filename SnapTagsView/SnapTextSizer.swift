import Foundation

public class SnapTextWidthSizers {

    internal var nonPurgingCache = [String: CGSize]()

    public init() { }

    public func calculateSizeForText(string: String, font: UIFont) -> CGSize {

        let key = "\(string)-\(font.fontName)-\(font.pointSize)"
        if let value = nonPurgingCache[key] {
            return value
        }

        let attrStr = NSMutableAttributedString(string:string)
        attrStr.addAttribute(NSFontAttributeName,
            value:font,
            range:NSMakeRange(0, string.characters.count))
        let size = attrStr.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: [], context: nil)

        nonPurgingCache[key] = size.size
        return size.size
    }

    public func calculateSizeForTag(string: String, configuration: SnapTagButtonConfiguration) -> CGSize {
        let textSize = self.calculateSizeForText(string.uppercaseString, font: configuration.font)

        var width = textSize.width
        width += configuration.labelInset.left + configuration.labelInset.right

        if configuration.hasOnOffButton {
            width -= configuration.labelInset.right
            width += configuration.onState.spacingBetweenLabelAndOnOffButton
            width += configuration.onState.buttonImage?.size.width ?? 0.0
            width += configuration.buttonInset.right
        }

        var height = textSize.height
        height += max(configuration.buttonInset.top, configuration.labelInset.top)
        height += max(configuration.buttonInset.bottom, configuration.labelInset.bottom)

        return CGSize(width: width, height: height)
    }

}
