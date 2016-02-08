import UIKit
import KTCenterFlowLayout
import UICollectionViewLeftAlignedLayout
import UICollectionViewRightAlignedLayout

private let reuseIdentifier = String(SnapTagCell)

public class SnapTagsCollectionViewController: UIViewController {

    public var data = [SnapTagRepresentation]()
    public var configuration : SnapTagsViewConfiguration!
    public var buttonConfiguration : SnapTagButtonConfiguration!
    public var delegate : SnapTagsButtonDelegate?

    internal var collectionView : UICollectionView!

    public lazy var sizer = SnapTextWidthSizers()

    override public func viewDidLoad() {
        super.viewDidLoad()

        assert(configuration != nil)
        assert(buttonConfiguration != nil)

        setupLayout()

        collectionView.delegate = self
        collectionView.dataSource = self

        setupConstraints()
        self.view.backgroundColor = UIColor.clearColor()

        // Register cell classes
        self.collectionView.registerNib(UINib(nibName: "SnapTagCell", bundle: NSBundle(forClass: SnapTagCell.self)), forCellWithReuseIdentifier: reuseIdentifier)

        /*
        delay(0.3) {
            print("\(self.collectionView.frame) in \(self.view.frame) in \(self.view.superview!.frame)")
        }*/

    }

    internal func setupLayout() {
        var layout : UICollectionViewFlowLayout
        if configuration.alignment == .Center {
            layout = KTCenterFlowLayout()
        } else if configuration.alignment == .Right {
            layout = UICollectionViewRightAlignedLayout()
        } else if configuration.alignment == .Left {
            layout = UICollectionViewLeftAlignedLayout()
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
        collectionView.backgroundColor = UIColor.clearColor()
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
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hMargin)-[cv]-(hMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[cv(>=height)]-(vMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }

    internal func calculateContentSizeForTag(tag: SnapTagRepresentation) -> CGSize {

        let size = sizer.calculateSizeFor(tag.tag, font: buttonConfiguration.font)
        var width = size.width
        width += buttonConfiguration.horizontalMargin * 2

        if buttonConfiguration.hasOnOffButton {
            width += buttonConfiguration.onState.spacingBetweenLabelAndOnOffButton
            width += buttonConfiguration.onState.buttonImage?.size.width ?? 0.0
        }

        var height = size.height
        height += buttonConfiguration.verticalMargin * 2

        return CGSizeMake(width, height)
    }

    public func allowBouncingHorizontally(horizontalBounce: Bool, vertically verticalBounce: Bool) {
        self.collectionView.bounces = horizontalBounce || verticalBounce
        self.collectionView.alwaysBounceHorizontal = horizontalBounce
        self.collectionView.alwaysBounceVertical = verticalBounce
    }

    public func calculateContentSizeForTags(tags: [SnapTagRepresentation]) -> CGSize {
        var width = CGFloat(0.0) // configuration.horizontalMargin * 2
        width += CGFloat(collectionView.numberOfItemsInSection(0) - 1) * configuration.spacing
        var height = CGFloat(0.0) // configuration.verticalMargin * 2 + configuration.contentHeight
        let sizes = tags.map { calculateContentSizeForTag($0) }
        height += sizes.reduce(CGFloat(0.0), combine: { (last, size) -> CGFloat in
            return fmax(last, size.height)
        })
        width += sizes.reduce(CGFloat(0.0), combine: { (sum, size) -> CGFloat in
            return sum + size.width
        })
        return CGSizeMake(width, height)
    }

    public func contentOffset() -> CGPoint {
        return collectionView.contentOffset
    }

    public func contentSize() -> CGSize {
        var size = collectionView.contentSize
        size.width += 2 * configuration.horizontalMargin
        size.height += 2 * configuration.verticalMargin
        return size
    }

    public var scrollEnabled : Bool {
        get {
            return collectionView.scrollEnabled
        }

        set(value) {
            collectionView.scrollEnabled = value
        }
    }

    public func reloadData() {
        collectionView.reloadData()
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

        let height = buttonConfiguration.verticalMargin * 2 + buttonConfiguration.font.pointSize

        let label = UILabel(frame: CGRectZero)
        label.text = tag.tag.uppercaseString
        label.font = buttonConfiguration.font

        let labelSize = sizer.calculateSizeFor(label.text ?? "", font: label.font)
        var width = buttonConfiguration.horizontalMargin * 2 + labelSize.width
        if buttonConfiguration.hasOnOffButton {
            width += buttonConfiguration.onState.spacingBetweenLabelAndOnOffButton + (buttonConfiguration.onState.buttonImage?.size.width ?? 0.0)
        }
        return CGSizeMake(width, height)
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegate {


    public func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return buttonConfiguration.canBeTurnedOnAndOff || buttonConfiguration.isTappable
    }

    public func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SnapTagCell
        cell.setHighlightState(true)
    }

    public func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SnapTagCell
        UIView.animateWithDuration(0.3) {
            cell.setHighlightState(false)
        }
    }

    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return buttonConfiguration.canBeTurnedOnAndOff || buttonConfiguration.isTappable
    }



    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

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

        return buttonConfiguration.canBeTurnedOnAndOff
    }

    public func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    public func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

    }



}
