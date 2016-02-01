import UIKit

class TagsBarView: UIScrollView , TagsBarButtonDelegate{
    
    private var tags:[String] = []
    private var tagButtons:[TagsBarButton] = []
    
    var tagdelegate: TagsBarViewDelegate?
    
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
        self.backgroundColor = UIColor(white: 32.0/255.0, alpha: 1.0) //same as bottom bar
        self.backgroundColor = Theme.getThemeColor()
        
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.scrollsToTop = false
    }

    func setTags(tags: [String], animate: Bool) {
        
        //check for any change!
        var change = false
        if tags.count != self.tags.count {
            change = true;
        } else {
            for (index, element) in tags.enumerate() {
                if element != self.tags[index] {
                    change = true
                    break
                }
            }
        }
        if !change {
            return;
        }
        
        self.tags = tags
        
        //clear
        self.tagButtons.removeAll(keepCapacity: true)
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        //scroll
        self.contentOffset = CGPointMake(0.0, 0.0)
        
        self.updateTags(animate)
    }
    
    private func updateTags(animate: Bool) {
        
        var contentSize = self.bounds.size
        
        let margin: CGFloat = 8.0
        let margin_vertical: CGFloat = 6.0
        
        //create new ones outside animation for nice slide-inn
        for i in 0..<tags.count {
            let tag = tags[i]
            
            if i < self.tagButtons.count {
                //ok
            } else  {
                let tagButton = TagsBarButton(tag: tag)
                self.tagButtons.append(tagButton)
                self.addSubview(tagButton)
                tagButton.delegate = self
                
                var frame = tagButton.frame
                frame.origin.x = contentSize.width + margin
                
                frame.origin.y = margin_vertical
                frame.size.height = self.frame.size.height - (margin_vertical * 2.0)
                
                tagButton.frame = frame
            }
        }
        
        //anim
        if(animate){
            UIView.beginAnimations(nil, context: nil)
        }
        
        //place them
        var x: CGFloat = margin
        for i in 0..<tags.count {
            
            var tagButton: TagsBarButton? = nil
            if i < self.tagButtons.count {
                tagButton = self.tagButtons[i]
            } else  {
                assert(false, "done abowe")
            }
            
            var frame = tagButton!.frame
            frame.origin.x = x
            
            
            tagButton!.frame = frame
            
            x += frame.size.width
            x += margin
        }
        
        if x > contentSize.width {
            contentSize.width = x
        }
        contentSize.height = self.frame.size.height
        
        //anim
        if(animate){
            UIView.commitAnimations()
        }
        
        self.contentSize = contentSize
    }
    
    //MARK:#TagsBarButtonDelegate
    
    func tagBarButton(tag: String) {
        self.tagdelegate?.tagBar(tag)
    }
}
