// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  case searchBarPlaceholder
}

extension L10n : CustomStringConvertible {
  var description : String { return self.string }

  var string : String {
    switch self {
      case .searchBarPlaceholder:
        return L10n.tr("searchBarPlaceholder")
    }
  }

  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
