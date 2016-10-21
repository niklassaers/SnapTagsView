source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, '9.0'

inhibit_all_warnings!

target 'SnapTagsView' do
  pod 'NSLayoutConstraint+ExpressionFormat'
  pod 'KTCenterFlowLayout', :git => "https://github.com/keighl/KTCenterFlowLayout.git", :commit => "a5b4a06a316cf070cf1b34a6fa1f52a9773b2b0c"
  pod 'UICollectionViewLeftAlignedLayout'
  pod 'UICollectionViewRightAlignedLayout'
end

target 'SnapTagsViewTests' do
  pod 'FBSnapshotTestCase'
end

target 'Example' do
  pod 'SnapTagsView', :path => '.'
end
