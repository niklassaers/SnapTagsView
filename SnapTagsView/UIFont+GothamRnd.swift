import Foundation

enum GothamRnd : String {
    case Bold = "GothamRounded-Bold"
    case BoldItalic = "GothamRounded-BoldItalic"
    case Book = "GothamRounded-Book"
    case BookItalic = "GothamRounded-BookItalic"
    case Medium = "GothamRounded-Medium"
    case MediumItalic = "GothamRounded-MediumItalic"
}

public extension UIFont {

    public static func boldWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.Bold.rawValue, size: size)!
    }

    public static func boldItalicWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.BoldItalic.rawValue, size: size)!
    }

    public static func bookWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.Book.rawValue, size: size)!
    }

    public static func bookItalicWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.BookItalic.rawValue, size: size)!
    }

    public static func mediumWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.Medium.rawValue, size: size)!
    }

    public static func mediumItalicWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.MediumItalic.rawValue, size: size)!
    }


}
