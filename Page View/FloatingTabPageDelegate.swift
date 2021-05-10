//
//  FloatingTabPageDelegate.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public protocol DugongFloatingTabPageScrollDelegate: AnyObject {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView)
}

public protocol DugongFloatingTabPageDelegate: UIViewController {
    var pageIndex: Int { get }
    var stickyHeaderChildScrollView: UIScrollView? { get }
    var delegate: DugongFloatingTabPageScrollDelegate? { get set }
}
