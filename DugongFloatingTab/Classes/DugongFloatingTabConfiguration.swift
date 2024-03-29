//
//  DugongFloatingTabConfiguration.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public final class DugongFloatingTabConfiguration {
    public var headerMaxHeight: CGFloat
    public var headerMinHeight: CGFloat
    public var menuTabHeight: CGFloat
    public var contentViewBackgroundColor: UIColor?
    public var selectedMenuTabItemUnderlineHeight: CGFloat = 2.5
    public var selectedMenuTabItemUnderlineColor: UIColor = .black
    public var menuTabBackgroundColor: UIColor?
    public var menuTabItemBackgroundColor: UIColor?
    public var menuTabItemLabelFont: UIFont?
    public var menuTabItemLabelTextColor: UIColor?
    public var menuTabSelectedItemLabelFont: UIFont?
    public var menuTabSeletedItemLabelTextColor: UIColor?
    public var menuTabItemEdgeInsetForSection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    public var minimumLineSpacing: CGFloat = 10
    public var minimumInteritemSpacing: CGFloat = 10
    public var headerBarShadow: Bool = false
    public var headerBarShadowColor: UIColor = .black
    public var headerBarShadowOffset: CGSize = .zero
    public var headerBarShadowRadius: CGFloat = 0
    public var headerBarShadowOpacity: Float = 0.3
    public var pageViewControllerSwipePagingDisable = false
    public var menuTabFixedPosition = false
    /// You may want to adjust scrollView's content inset manually when page is changing (Especially adjusting plain style tableview section header view). Then set to false
    public var adjustScrollViewContentInset = true
    

    /// Set DugongStickyHeader's height. DugongStickyHeader's height would be headerMaxHeight + menuTabHeight
    /// - Parameters:
    ///   - headerMaxHeight: headerView's maximum height. Actual headerView's maximum height could be headerMaxHeight + menuTabHeight
    ///   - headerMinHeight: headerView's minimum height. Actual headerView's minimum height could be headerMinHeight + menuTabHeight
    ///   - menuTabHeight: menu tab's height.
    public init(headerMaxHeight: CGFloat, headerMinHeight: CGFloat, menuTabHeight: CGFloat) {
        self.headerMaxHeight = headerMaxHeight
        self.headerMinHeight = headerMinHeight + menuTabHeight
        self.menuTabHeight = menuTabHeight
    }
}
