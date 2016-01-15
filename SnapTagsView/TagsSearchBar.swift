import UIKit

protocol TagsSearchBarDelegate {
    func tagSearch(changed: String, active: Bool)
    func tagSearchBegin()
    func tagSearchEnd(text: String) //also called when stuff is added while not active
}

protocol TagsSearchAutocompleteViewDelegate {
    func tagAutocompleteSetQuery(text: String)
}

class TagsSearchBar: UIView {

    let searchBar = UISearchBar()
    let tagsScrollView = UIScrollView()
    let tagsView = TagsView()
    
    var currentText = ""
    
    var tagdelegate: TagsSearchBarDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func awakeFromNib() {
        
    }

    private func commonInit() {
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.searchBar)
        self.configureSearchBar()
        self.configureTagsViewAsSubviewOf(self.searchBar)
    }
    
    func setScrollViewFrameToView(view: UIView) -> CGRect {
        
        let margin = 10.0 as CGFloat
        var scrollViewFrame = view.bounds
        scrollViewFrame.origin.x = 1
        scrollViewFrame.origin.y = margin
        scrollViewFrame.size.height -= 2 * margin
        scrollViewFrame.size.width -= 2
        self.tagsScrollView.frame = scrollViewFrame
        return scrollViewFrame
    }
    
    func configureTagsViewAsSubviewOf(view: UIView) {
        
        let scrollViewFrame = setScrollViewFrameToView(view)
        
        self.tagsScrollView.backgroundColor = UIColor.clearColor()
        view.addSubview(self.tagsScrollView)
        self.tagsScrollView.delegate = self
        self.tagsScrollView.showsHorizontalScrollIndicator = false
        self.tagsScrollView.showsVerticalScrollIndicator = false
        self.tagsScrollView.scrollEnabled = true
        
        self.tagsView.defaultHorizontalMargin = 2.0 as CGFloat
        self.tagsView.defaultVerticalMargin = 0.0 as CGFloat
        self.tagsView.defaultSpacing = 5.0 as CGFloat
        self.tagsView.defaultHeight = scrollViewFrame.size.height
        
        self.tagsScrollView.addSubview(self.tagsView)
        self.tagsView.delegate = self
        self.tagsView.backgroundColor = UIColor.clearColor()
        
        let parameters = ["tagsView": self.tagsView, "scrollView": self.tagsScrollView]
        self.tagsScrollView.addConstraint(NSLayoutConstraint(expressionFormat: "tagsView.leading = scrollView.leading", parameters: parameters))
        self.tagsScrollView.addConstraint(NSLayoutConstraint(expressionFormat: "tagsView.trailing = scrollView.trailing", parameters: parameters))
        self.tagsScrollView.addConstraint(NSLayoutConstraint(expressionFormat: "tagsView.top = scrollView.top", parameters: parameters))
        self.tagsScrollView.addConstraint(NSLayoutConstraint(expressionFormat: "tagsView.bottom = scrollView.bottom", parameters: parameters))
        
        let tapToSearchGr = UITapGestureRecognizer(target: self, action: "tagsViewTapped:")
        self.tagsView.addGestureRecognizer(tapToSearchGr)
        
        self.updateTagsView()
    }
    
    func tagsViewTapped(tapGr : UITapGestureRecognizer) {
        self.hideTagsView()
        self.searchBar.becomeFirstResponder()
        self.searchBar.setCursorPositionToEnd()
    }
    
    func tagViewIsHidden() -> Bool {
        return self.tagsScrollView.hidden;
    }
    
    func showTagsView() {
        self.setScrollViewFrameToView(self.searchBar)
        
        self.tagsScrollView.hidden = false
        self.searchBar.text = ""
        self.searchBar.hideHourGlassIcon()
        
        self.searchBar.placeholder = self.currentText != "" ? "" : NSLocalizedString("searchBarPlaceholder", comment:"")

        self.updateTagsView()
    }

    func hideTagsView() {
        self.searchBar.placeholder = NSLocalizedString("searchBarPlaceholder", comment:"")
        self.searchBar.showHourGlassIcon()
        self.searchBar.text = self.currentText
        self.tagsScrollView.hidden = true

    }
    
    func updateTagsView() {
        var frame = self.tagsScrollView.bounds
        let origFrame = frame
        frame.size.width = CGFloat(FLT_MAX)
        self.tagsView.frame = frame
        
        let tags = self.currentText.uppercaseString.componentsSeparatedByString(" ").filter { (element) -> Bool in
            return element != nil && element != ""
        }
        
        if tags.count == 0 {
            self.tagsView.frame = origFrame
            self.hideTagsView()
            return
        }
        
        self.tagsView.alignment = .Left
        self.tagsView.boundsForDeterminingWidth = self.tagsView.bounds
        let tagsViewSize = self.tagsView.populateTagViewWithTagsAndDetermineHeight(tags, turnOnOffAble: true, horizontalMargin: 5)
        frame.size = tagsViewSize
        frame.origin.x = 0
        frame.size.width += 50.0 // 50.0 as CGFloat // so the user has something to tap on
        self.tagsView.frame = frame
        frame.size.height -= 3
        self.tagsScrollView.contentSize = frame.size
        
        let scrollX = fmax(0, self.tagsScrollView.contentSize.width - self.tagsScrollView.bounds.width)
        dispatchOnMainAfter(0.2) {
            self.tagsScrollView.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
        }
    }
    
    func configureSearchBar() {
    
        self.searchBar.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.searchBar.frame = self.bounds
        self.searchBar.backgroundColor = UIColor.clearColor()
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("searchBarPlaceholder", comment:"")
        
        self.searchBar.tintColor = UIColor.roseColor()
        
        self.searchBar.autocapitalizationType = UITextAutocapitalizationType.None
        
        //transparent bkg
        self.searchBar.translucent = true
        self.searchBar.backgroundImage = UIImage()
        
        self.searchBar.tintColor = UIColor.whiteColor()
    }
    
    func getText() -> String {
        return self.currentText
    }
    
    func search(text: String) {
        self.searchBar.text = text.lowercaseString
        self.currentText = text.lowercaseString
//        self.updateTagsView()
        self.tagdelegate?.tagSearch(text, active: self.searchBar.isFirstResponder())
        self.showTagsView()

    }
    
    func clear() {
        self.searchBar.text = ""
        self.currentText = ""
        self.updateTagsView()
    }
}

extension TagsSearchBar : UIScrollViewDelegate {
    
}

extension TagsSearchBar : TagsBarViewDelegate {

    func tagBar(selected: String) {
        if self.currentText == "" {
            self.currentText = selected
        } else {
            self.currentText = self.currentText + " " + selected.lowercaseString
        }
        
        if self.tagViewIsHidden() {
            self.searchBar.text = self.currentText
        } else {
            self.showTagsView()
        }
        
        self.tagdelegate?.tagSearch(self.currentText, active: self.searchBar.isFirstResponder())
    }
}

extension TagsSearchBar : TagsSearchAutocompleteViewDelegate {
    
    func tagAutocompleteSetQuery(text: String) {
        self.searchBar.text = text
        self.currentText = text
        self.searchBar.resignFirstResponder()
    }
}

extension TagsSearchBar : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // This is where we should normally deal with the clear button: http://stackoverflow.com/questions/1092246/uisearchbar-clearbutton-forces-the-keyboard-to-appear/3852509#3852509
        
        self.currentText = searchText
        self.tagdelegate?.tagSearch(searchText, active: self.searchBar.isFirstResponder())
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.hideTagsView()
        return true
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.tagdelegate?.tagSearchBegin()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.currentText = searchBar.text ?? ""
        self.tagdelegate?.tagSearchEnd(self.currentText)

        self.updateTagsView()
        
        dispatchOnMainAfter(0.1) {
            self.showTagsView()
        }
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.setScrollViewFrameToView(searchBar)
    }
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        //ignore
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.text = ""
        self.currentText = ""
        self.searchBar.showsCancelButton = false
            
        self.searchBar.resignFirstResponder()
    }
    

}

extension TagsSearchBar : TagsButtonDelegate {

    func tagButtonTapped(tag: String) {
//        Navigator2Context.getContext().showSearchWithQuery(tag)
        
        self.tagButtonTurnedOff(tag)
    }
    
    func tagButtonTurnedOff(tag: String) {

        let tags = self.currentText.uppercaseString.componentsSeparatedByString(" ").filter { (element) -> Bool in
            return element != tag
        }
        self.currentText = tags.joinWithSeparator(" ")
        //self.updateTagsView()
        
        self.search(self.currentText)
    }

}



