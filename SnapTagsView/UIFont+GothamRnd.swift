import Foundation

enum GothamRnd : String {
    case Bold = "GothamRnd-Bold"
    case BoldItalic = "GothamRnd-BoldIta"
    case Book = "GothamRnd-Book"
    case BookItalic = "GothamRnd-BookIta"
    case Medium = "GothamRnd-Medium"
    case MediumItalic = "GothamRnd-MedIta"
}

extension UIFont {
    
    static func boldWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.Bold.rawValue, size: size)!
    }
    
    static func boldItalicWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.BoldItalic.rawValue, size: size)!
    }
    
    static func bookWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.Book.rawValue, size: size)!
    }
    
    static func bookItalicWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.BookItalic.rawValue, size: size)!
    }
    
    static func mediumWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.Medium.rawValue, size: size)!
    }
    
    static func mediumItalicWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: GothamRnd.MediumItalic.rawValue, size: size)!
    }
    
    
}