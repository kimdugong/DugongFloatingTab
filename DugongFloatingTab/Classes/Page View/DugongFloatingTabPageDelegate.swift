//
//  DugongFloatingTabPageDelegate.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public protocol DugongFloatingTabPageScrollDelegate: AnyObject {
    func childViewScrollViewDidScroll(_ scrollView: UIScrollView)
    func reloadFloatingTabPage()
}

public protocol DugongFloatingTabPageDelegate: UIViewController {
    var pageIndex: Int { get }
    var stickyHeaderChildScrollView: UIScrollView? { get }
    var delegate: DugongFloatingTabPageScrollDelegate? { get set }
}

protocol DugongFloatingTabPageViewControllerDelegate: AnyObject {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func pageIndexDidChange(index: Int, previous: Int)
}
