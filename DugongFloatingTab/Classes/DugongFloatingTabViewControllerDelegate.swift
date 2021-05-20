//
//  DugongFloatingTabViewControllerDelegate.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/20.
//

import Foundation

public protocol DugongFloatingTabViewControllerDelegate: AnyObject {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    func pageIndexDidChange(index: Int)
}
