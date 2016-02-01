// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

public extension UIImage {
  public enum Asset : String {
    case RedCloseButton = "RedCloseButton"
    case RoundedButton = "RoundedButton"
    case RoundedButton_WhiteWithGreyBorder = "RoundedButton_WhiteWithGreyBorder"
    case RoundedButtonFilled = "RoundedButtonFilled"
    case YellowCloseButton = "YellowCloseButton"

    public var image: UIImage {
      return UIImage(asset: self)
    }
  }

  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}

