import UIKit

open class SnapSearchBarController : UIViewController {

    open lazy var sizer = SnapTextWidthSizers()
    open var configuration : SnapTagsViewConfiguration!
    open var buttonConfiguration : SnapTagButtonConfiguration!
    open var height : CGFloat = 36.0
    fileprivate var tagScrollView : UIScrollView?
    fileprivate var searchTextField : UITextField?
    internal let tagsVc = SnapTagsCollectionViewController()
    fileprivate var searchBarInteractionEnabled = false

    open var placeholderText : String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    fileprivate var placeholderTextRepresentation : String {
        get {
            if data.count == 0 {
                if let placeholderText = placeholderText {
                    return placeholderText
                } else {
                    return "Hva leter du etter?"
                }
            } else {
                return ""
            }
        }
    }

    open var searchBar : UISearchBar {
        get {
            return self.view as! UISearchBar
        }
    }

    open var data : [SnapTagRepresentation] {
        get {
            return tagsVc.data
        }
        set(value) {
            tagsVc.data = value
            updatePlaceholder()
        }
    }

    open var delegate : SnapTagsButtonDelegate? {
        get {
            return tagsVc.delegate
        }
        set(value) {
            tagsVc.delegate = value
        }
    }


    open override func viewDidLoad() {
        super.viewDidLoad()
        assert(configuration != nil)
        assert(buttonConfiguration != nil)

        configuration.alignment = .natural
        tagsVc.configuration = configuration
        tagsVc.buttonConfiguration = buttonConfiguration
        tagsVc.handlesViewConfigurationMargins = false

        searchBar.delegate = self
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
        searchBarInteractionEnabled = false

        var searchTextField_ : UITextField? = nil
        for firstLevelSubview in searchBar.subviews {
            for subview in firstLevelSubview.subviews {
                if let subview = subview as? UITextField {
                    searchTextField_ = subview
                    break
                }
            }
        }
        

        guard let searchTextField = searchTextField_ else {
            print("Could not find textfield in searchbar")
            return
        }

        searchTextField.leftViewMode = .never
        searchTextField.rightViewMode = .never
        searchTextField.textAlignment = .natural
        searchTextField.textColor = UIColor.black
        searchTextField.tintColor = UIColor.roseColor()
        self.searchTextField = searchTextField

        let hMargin = configuration.horizontalMargin
        let vMargin = configuration.verticalMargin
        
        tagScrollView = SnapTagsHorizontalScrollView.setupTagScrollViewAsSubviewOf(searchBar, horizontalMargin: hMargin, verticalMargin: vMargin)

        self.addChildViewController(tagsVc)
        tagScrollView?.addSubview(tagsVc.view)

        var constraints = [NSLayoutConstraint]()
        let dict = ["self": tagsVc.view!, "super": tagScrollView!]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom", parameters: dict))
        tagScrollView?.addConstraints(constraints)

        tagsVc.scrollEnabled = false
        tagsVc.view.translatesAutoresizingMaskIntoConstraints = true

        var frame = tagsVc.view.frame
        frame.size.width = tagsVc.calculateContentSizeForTags(data).width
        frame.size.height = tagScrollView?.frame.height ?? 0.0
        tagsVc.view.frame = frame

        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        var textFieldFrame = searchTextField.frame
        textFieldFrame.size.height = 34
        searchTextField.frame = textFieldFrame

        updatePlaceholder()
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        tagsVc.scrollEnabled = true
    }
    
    open func setFont(_ font: UIFont) {
        searchTextField?.font = font
    }

    override open func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //self.searchBar.layoutIfNeeded()
        //self.searchBar.layoutSubviews()

        let newHeight: CGFloat = self.height
        for subView in searchBar.subviews
        {
            for subsubView in subView.subviews
            {
                if let textField = subsubView as? UITextField
                {
                    var currentTextFieldBounds = textField.bounds
                    currentTextFieldBounds.size.height = newHeight
                    textField.bounds = currentTextFieldBounds
                    textField.borderStyle = UITextBorderStyle.roundedRect
                }
            }
        }
    }
    
    open func beginEditingWithSearch(_ text: String) {
        tagScrollView?.isHidden = true
        searchBarInteractionEnabled = true
        
        searchBar.text = text
        searchTextField?.becomeFirstResponder()
    }
    
    open func updateSearchString(_ text: String) {
        searchBar.text = text
    }
    
    open func updatePlaceholder() {
        searchBar.placeholder = placeholderTextRepresentation
    }
    
    open func endEditing(_ cancelled: Bool) -> String {
        tagScrollView?.isHidden = false
        searchBarInteractionEnabled = false
        
        searchBar.resignFirstResponder()
        searchTextField?.resignFirstResponder()
        let newText = searchBar.text ?? ""
        searchBar.text = ""
        
        if cancelled {
            let oldText = data.map { $0.tag }.joined(separator: " ")
            updatePlaceholder()
            delegate?.searchCompletedWithString?(oldText)
            return oldText
        }
        
        else {
            let newData = newText.components(separatedBy: " ").map { SnapTagRepresentation(tag: $0) }
            self.data = newData
            reloadData()

            updatePlaceholder()
            delegate?.searchCompletedWithString?(newText)
            return newText
        }
    }
    
    open func reloadData() {
        tagsVc.reloadData()
        delay(0.2) {
            if let sv = self.tagScrollView?.subviews.first?.subviews.first as? UIScrollView {
                let x = fmax(0.0, (sv.contentSize.width - sv.bounds.size.width))
                sv.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            }
        }
    }
}

extension SnapSearchBarController : UISearchBarDelegate {
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return searchBarInteractionEnabled
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchBar.text = searchBar.text?.uppercaseString
        delegate?.searchTextChanged?(searchBar.text ?? "")
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let _ = endEditing(false)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let _ = endEditing(true)
    }
}
