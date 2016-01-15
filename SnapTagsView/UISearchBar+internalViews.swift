import Foundation

extension UISearchBar {

    internal func getTextField() -> UITextField {
        let textFieldInsideSearchBar = self.valueForKey("searchField") as! UITextField
        return textFieldInsideSearchBar
    }

    func hideHourGlassIcon() {
        let textFieldInsideSearchBar = self.getTextField()
        textFieldInsideSearchBar.leftViewMode = UITextFieldViewMode.Never
    }

    func showHourGlassIcon() {
        let textFieldInsideSearchBar = self.getTextField()
        textFieldInsideSearchBar.leftViewMode = UITextFieldViewMode.Always
    }

    func setCursorPositionToEnd() {
        let textFieldInsideSearchBar = self.getTextField()
        let endPos = textFieldInsideSearchBar.endOfDocument
        let range = textFieldInsideSearchBar.textRangeFromPosition(endPos, toPosition: endPos)
        textFieldInsideSearchBar.selectedTextRange = range
    }
}
