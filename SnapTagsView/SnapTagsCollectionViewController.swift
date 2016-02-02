import UIKit
import KTCenterFlowLayout

private let reuseIdentifier = String(SnapTagCell)

public class SnapTagsCollectionViewController: UIViewController {
    
    public var data = [SnapTagRepresentation]()
    public var configuration : SnapTagsViewConfiguration!
    public var buttonConfiguration : SnapTagButtonConfiguration!
    public var delegate : SnapTagsButtonDelegate?
    
    internal var collectionView : UICollectionView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        assert(configuration != nil)
        assert(buttonConfiguration != nil)
//        assert(self.view.superview != nil)
        
        setupLayout()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupConstraints()

        // Register cell classes
        self.collectionView.registerClass(SnapTagCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    internal func setupLayout() {
        var layout : UICollectionViewFlowLayout
        if configuration.alignment == .Center {
            layout = KTCenterFlowLayout()
        } else {
            layout = UICollectionViewFlowLayout()
        }
        
        layout.minimumLineSpacing = configuration.spacing
        layout.minimumInteritemSpacing = configuration.spacing
        layout.estimatedItemSize = buttonConfiguration.intrinsicContentSize
        layout.scrollDirection = configuration.scrollDirection
        layout.headerReferenceSize = CGSizeZero
        layout.footerReferenceSize = CGSizeZero
        layout.sectionInset = UIEdgeInsetsZero
        layout.itemSize = buttonConfiguration.intrinsicContentSize
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
    }
    
    internal func setupConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let metrics = [
            "hMargin": configuration.horizontalMargin,
            "vMargin": configuration.verticalMargin,
            "height": configuration.contentHeight]
        let views = [ "cv": collectionView ]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(hMargin)-[cv]-(hMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(vMargin)-[cv(height)]-(vMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDataSource {

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let tag = data[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SnapTagCell
        let config = buttonConfiguration.duplicate()
        
        config.isOn = tag.isOn
        cell.applyConfiguration(buttonConfiguration)
        cell.setText(tag.tag)
        
        return cell
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegate {

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
