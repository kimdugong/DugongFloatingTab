//
//  DugongFloatingTabConfiguration.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public class DugongFloatingTabConfiguration {
    public let headerMaxHeight: CGFloat
    public let headerMinHeight: CGFloat
    public let menuTabHeight: CGFloat
    public var contentViewBackgroundColor: UIColor?
    public var selectedMenuTabItemUnderlineHeight: CGFloat = 2.5
    public var selectedMenuTabItemUnderlineColor: UIColor = .black
    public var menuTabBackgroundColor: UIColor?
    public var menuTabItemBackgroundColor: UIColor?
    public var menuTabItemLabelFont: UIFont?
    public var menuTabItemLabelTextColor: UIColor?
    public var menuTabItemEdgeInsetForSection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    public var minimumLineSpacing: CGFloat = 10

    /// Set DugongStickyHeader's height. DugongStickyHeader's height would be headerMaxHeight + menuTabHeight
    /// - Parameters:
    ///   - headerMaxHeight: headerView's maximum height.
    ///   - headerMinHeight: headerView's minimum height. If you want menu tab floating effect, headerMinHeight should be greater than menuTabHeight.
    ///   - menuTabHeight: menu tab's height.
    public init(headerMaxHeight: CGFloat, headerMinHeight: CGFloat, menuTabHeight: CGFloat) {
        self.headerMaxHeight = headerMaxHeight
        self.headerMinHeight = headerMinHeight
        self.menuTabHeight = menuTabHeight
    }
}
