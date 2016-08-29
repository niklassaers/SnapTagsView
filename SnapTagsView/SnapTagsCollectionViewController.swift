import UIKit
import KTCenterFlowLayout
import UICollectionViewLeftAlignedLayout
import UICollectionViewRightAlignedLayout

private let reuseIdentifier = String(SnapTagCell)

public class SnapTagsCollectionViewController: UIViewController {

    public var data = [SnapTagRepresentation]()
    public var configuration : SnapTagsViewConfiguration!
    public var buttonConfiguration : SnapTagButtonConfiguration!
    public weak var delegate : SnapTagsButtonDelegate?

    internal var collectionView : UICollectionView?
    internal var handlesViewConfigurationMargins = true

    public lazy var sizer = SnapTextWidthSizers()

    override public func viewDidLoad() {
        super.viewDidLoad()

        assert(configuration != nil)
        assert(buttonConfiguration != nil)

        setupLayout()

        collectionView?.delegate = self
        collectionView?.dataSource = self

        setupConstraints()
        self.view.backgroundColor = UIColor.clearColor()
        collectionView?.userInteractionEnabled = true

        // Register cell classes
        collectionView?.registerNib(UINib(nibName: "SnapTagCell", bundle: NSBundle(forClass: SnapTagCell.self)), forCellWithReuseIdentifier: reuseIdentifier)
    }

    internal func setupLayout() {
        var layout : UICollectionViewFlowLayout
        if configuration.alignment == .Center {
            layout = KTCenterFlowLayout()
        } else if configuration.alignment == .Right {
            layout = UICollectionViewRightAlignedLayout()
        } else if configuration.alignment == .Left {
            layout =  UICollectionViewLeftAlignedLayout()
        } else {
            layout = LessBuggyCollectionViewFlowLayout()
        }

        layout.minimumLineSpacing = configuration.spacing
        layout.minimumInteritemSpacing = configuration.spacing
        layout.scrollDirection = configuration.scrollDirection
        layout.headerReferenceSize = CGSizeZero
        layout.footerReferenceSize = CGSizeZero
        layout.sectionInset = configuration.padding
        layout.itemSize = buttonConfiguration.intrinsicContentSize

        // KTCenterFlowLayout crashes if estimatedItemSize != (0.0, 0.0) (see their README on GitHub)
        if configuration.alignment != .Center {
            layout.estimatedItemSize = buttonConfiguration.intrinsicContentSize
        }


        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = UIColor.clearColor()
            
            let backgroundView = UIView()
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundView = backgroundView
            backgroundView.backgroundColor = UIColor.clearColor()
            let tapGr = UITapGestureRecognizer(target: self, action: #selector(SnapTagsCollectionViewController.tappedOutsideCell))
            backgroundView.addGestureRecognizer(tapGr)
            
            let viewDict = [ "collectionView": collectionView, "backgroundView": backgroundView ]
            let leading = NSLayoutConstraint(expressionFormat: "backgroundView.leading = collectionView.leading", parameters: viewDict)
            let trailing = NSLayoutConstraint(expressionFormat: "backgroundView.trailing = collectionView.trailing", parameters: viewDict)
            let top = NSLayoutConstraint(expressionFormat: "backgroundView.top = collectionView.top", parameters: viewDict)
            let bottom = NSLayoutConstraint(expressionFormat: "backgroundView.bottom = collectionView.bottom", parameters: viewDict)
            collectionView.addConstraints([leading, trailing, top, bottom])
            
            view.addSubview(collectionView)
        }
    }
    
    @objc private func tappedOutsideCell(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tappedOutsideTagButtons?()
    }

    internal func setupConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        var configuration = self.configuration
        if !handlesViewConfigurationMargins {
            configuration.horizontalMargin = 0.0
            configuration.verticalMargin = 0.0
        }

        let metrics = [
            "hMargin": configuration.horizontalMargin,
            "vMargin": configuration.verticalMargin]
        let views = [ "cv": collectionView ]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hMargin)-[cv]-(hMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[cv]-(vMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }

    public func allowBouncingHorizontally(horizontalBounce: Bool, vertically verticalBounce: Bool) {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.bounces = horizontalBounce || verticalBounce
        collectionView.alwaysBounceHorizontal = horizontalBounce
        collectionView.alwaysBounceVertical = verticalBounce
    }

    public func calculateContentSizeForTags(tags: [SnapTagRepresentation]) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSizeZero
        }

        var width = CGFloat(0.0)
        width += fmax(0.0 ,CGFloat(collectionView.numberOfItemsInSection(0) - 1) * configuration.spacing)
        var height = CGFloat(0.0)
        let sizes = tags.map { sizer.calculateSizeForTag($0.tag, configuration: buttonConfiguration) }
        height += sizes.reduce(CGFloat(0.0), combine: { (last, size) -> CGFloat in
            return fmax(last, size.height)
        })
        width += sizes.reduce(CGFloat(0.0), combine: { (sum, size) -> CGFloat in
            return sum + size.width
        })
        return CGSizeMake(width, height)
    }

    public func contentOffset() -> CGPoint {
        return collectionView?.contentOffset ?? CGPointMake(0,0)
    }

    public func contentSize() -> CGSize {
        var size = collectionView?.contentSize ?? CGSizeMake(0, 0)
        size.width += 2 * configuration.horizontalMargin
        size.height += 2 * configuration.verticalMargin
        return size
    }

    public var scrollEnabled : Bool {
        get {
            return collectionView?.scrollEnabled ?? false
        }

        set(value) {
            collectionView?.scrollEnabled = value
        }
    }

    public func reloadData() {
        collectionView?.reloadData()
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
        
        let tag : SnapTagRepresentation
        
        // Guard against reload situations where the indexpath and data are out of sync
        if indexPath.item < data.count {
            tag = data[indexPath.item]
        } else {
            tag = SnapTagRepresentation(tag: "OutOfBounds", isOn: false)
        }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SnapTagCell
        var config = buttonConfiguration

        cell.sizer = sizer
        config.isOn = tag.isOn
        cell.applyConfiguration(config)
        cell.setText(tag.tag)

        return cell
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let tag = data[indexPath.item]
        let size = sizer.calculateSizeForTag(tag.tag ?? "", configuration: buttonConfiguration)

        return CGSize(width: round(size.width), height: round(size.height))
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegate {

//    private func printIsMainThread() {
//        let t = NSThread.isMainThread()
//        if t {
//            print("Is main thread")
//        } else {
//            print("IS NOT MAIN THREAD!!!!!")
//        }
//    }

    public func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        printIsMainThread()
//        print("shouldHighlightItemAtIndexPath")
        return buttonConfiguration.canBeTurnedOnAndOff || buttonConfiguration.isTappable
    }

    public func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        printIsMainThread()
//        print("didHighlightItemAtIndexPath")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SnapTagCell
        cell.setHighlightState(true)
    }

    public func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
//        printIsMainThread()
//        print("didUnhighlightItemAtIndexPath")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SnapTagCell
        UIView.animateWithDuration(0.3) {
            cell.setHighlightState(false)
        }
    }

    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        printIsMainThread()
//        print("shouldSelectItemAtIndexPath")
        return buttonConfiguration.canBeTurnedOnAndOff || buttonConfiguration.isTappable
    }



    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        printIsMainThread()
//        print("didSelectItemAtIndexPath")
        let tag = data[indexPath.row]
        if buttonConfiguration.canBeTurnedOnAndOff {
            tag.isOn = !tag.isOn
            data[indexPath.row] = tag

            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SnapTagCell
            UIView.animateWithDuration(0.3) {
                if tag.isOn {
                    cell.setOnState()
                } else {
                    cell.setOffState()
                }
            }
            
            delegate?.snapTagButtonTapped(tag, sender: self)
            if tag.isOn {
                delegate?.snapTagButtonTurnedOn?(tag.tag)
            } else {
                delegate?.snapTagButtonTurnedOff?(tag.tag)
            }
            
        } else if buttonConfiguration.isTappable {
            delegate?.snapTagButtonTapped(tag, sender: self)
        }
    }


    public func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        printIsMainThread()
        return buttonConfiguration.canBeTurnedOnAndOff
    }

    public func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    public func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

    }



}
