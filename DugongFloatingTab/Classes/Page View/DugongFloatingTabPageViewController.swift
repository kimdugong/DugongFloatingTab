//
//  DugongFloatingTabPageViewController.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

class DugongFloatingTabPageViewController: UIPageViewController {
    private let pages: [UIViewController]
    private let option: DugongFloatingTabConfiguration

    var visiablePageIndex: Int = 0 {
        willSet {
            pageViewDelegate?.pageIndexWillChange(index: newValue)
        }
    }
    
    weak var pageViewDelegate: DugongFloatingTabPageViewControllerDelegate?

    init(pages: [DugongFloatingTabPageDelegate], option: DugongFloatingTabConfiguration) {
        self.pages = pages
        self.option = option
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        guard let childVC = pages.first as? DugongFloatingTabPageDelegate else {
            return
        }
        self.setViewControllers([childVC], direction: .forward, animated: true, completion: nil)
    }

    func pagingTo(toIndex index: Int, navigationDirection direction: UIPageViewController.NavigationDirection, headerViewHeight: CGFloat) {
        self.setViewControllers([pages[index]], direction: direction, animated: true) { [self]_ in
            guard let childVC = pages[index] as? DugongFloatingTabPageDelegate else { return }
            childVC.delegate = self.parent as? DugongFloatingTabPageScrollDelegate
            if childVC.stickyHeaderChildScrollView?.contentOffset.y ?? 0 + headerViewHeight <= (option.headerMaxHeight + option.menuTabHeight) {
                childVC.stickyHeaderChildScrollView?.contentOffset.y = -headerViewHeight
                childVC.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight + option.menuTabHeight, left: 0, bottom: 0, right: 0)
            }
        }
    }
}

extension DugongFloatingTabPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }

        return pages[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageViewDelegate?.pageViewController(pageViewController, willTransitionTo: pendingViewControllers)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let child = pageViewController.viewControllers?.last as? DugongFloatingTabPageDelegate else {
            return
        }
        visiablePageIndex = child.pageIndex
        pageViewDelegate?.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [String: Any]?) -> [UIPageViewController.OptionsKey: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIPageViewController.OptionsKey(rawValue: key), value)})
}