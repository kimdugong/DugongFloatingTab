//
//  ViewController.swift
//  DugongFloatingTab
//
//  Created by kimdugong on 05/10/2021.
//  Copyright (c) 2021 kimdugong. All rights reserved.
//

import UIKit
import DugongFloatingTab

class ViewController: UIViewController {
    @IBOutlet weak var container: UIView!

    private var tabTitle: [String] = []
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        return view
    }()

    private lazy var floatingTabViewController : DugongFloatingTabViewController = {
        let option = DugongFloatingTabConfiguration(headerMaxHeight: 100, headerMinHeight: 0, menuTabHeight: 40)
        option.contentViewBackgroundColor = .yellow
        option.selectedMenuTabItemUnderlineHeight = 2.5
        option.selectedMenuTabItemUnderlineColor = .black
        option.menuTabBackgroundColor = .systemTeal
        option.menuTabItemBackgroundColor = .white
        option.menuTabSelectedItemLabelFont = UIFont.boldSystemFont(ofSize: 14)
        option.menuTabSeletedItemLabelTextColor = .black
        option.menuTabItemLabelFont = UIFont.systemFont(ofSize: 14)
        option.menuTabItemLabelTextColor = .gray
        option.menuTabItemEdgeInsetForSection = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        option.minimumLineSpacing = 10
        option.headerBarShadow = true
        option.headerBarShadowOffset = CGSize(width: 0, height: 0.5)
        option.headerBarShadowOpacity = 0.2
        option.headerBarShadowRadius = 3
        option.pageViewControllerSwipePagingDisable = false
        option.menuTabFixedPosition = false

        let floatingTabViewController = DugongFloatingTabViewController(headerView: headerView, option: option)
        floatingTabViewController.delegate = self
        return floatingTabViewController
    }()

    private lazy var pages: [DugongFloatingTabPageDelegate] = {
        let tabTitle: [String] = ["camel", "dugong", "quokka", "elephant", "hedgehog", "panda", "lion"]
        let pages = tabTitle.enumerated().compactMap { (index, title) -> DugongFloatingTabPageDelegate? in
            guard let child = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page") as? PageViewController else { return nil }
            child.pageIndex = index
            child.title = title
            return child
        }
        return pages
    }()

    override func viewDidLoad() {
        container.addSubview(floatingTabViewController.view)
        floatingTabViewController.view.frame = floatingTabViewController.view.superview?.bounds ?? .zero
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fakeFetchTabTitle()
    }

    private func fakeFetchTabTitle() {
        sleep(10)
        let pages = ["lion", "camel", "dugong", "quokka", "elephant", "hedgehog", "panda"].enumerated().compactMap { (index, title) -> DugongFloatingTabPageDelegate? in
            guard let child = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page") as? PageViewController else { return nil }
            child.pageIndex = index
            child.title = title
            return child
        }
        floatingTabViewController.pages = pages
    }
}

extension ViewController: DugongFloatingTabViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    func pageIndexDidChange(index: Int, previous: Int) {
        print(previous, "--->", index)
    }
    
}
