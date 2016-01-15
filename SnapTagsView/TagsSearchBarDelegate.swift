import Foundation

protocol TagsSearchBarDelegate {
    func tagSearch(changed: String, active: Bool)
    func tagSearchBegin()
    func tagSearchEnd(text: String) //also called when stuff is added while not active
}
