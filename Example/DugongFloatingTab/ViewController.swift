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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stickyHeaderView : DugongFloatingTabViewController = {
        let option = DugongFloatingTabConfiguration(headerMaxHeight: 200, headerMinHeight: 50, menuTabHeight: 50)
        option.contentViewBackgroundColor = .yellow
        option.selectedMenuTabItemUnderlineHeight = 2.5
        option.selectedMenuTabItemUnderlineColor = .black
        option.menuTabBackgroundColor = .systemTeal
        option.menuTabItemBackgroundColor = .white

        option.menuTabItemLabelFont = UIFont.boldSystemFont(ofSize: 20)
        option.menuTabItemLabelTextColor = .black
        option.menuTabItemEdgeInsetForSection = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        option.minimumLineSpacing = 10

        let stickyHeaderView = DugongFloatingTabViewController(pages: pages, headerView: headerView, option: option)
        return stickyHeaderView
    }()

    private let pages: [DugongFloatingTabPageDelegate] = {
        let tabTitle: [String] = ["camel", "dugong", "quokka", "elephant", "panda", "hedgehog"]
        let pages = tabTitle.enumerated().compactMap { (index, title) -> DugongFloatingTabPageDelegate? in
            guard let child = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page") as? PageViewController else { return nil }
            child.pageIndex = index
            child.title = title
            return child
        }
        return pages
    }()

    override func viewDidLoad() {
        container.addSubview(stickyHeaderView.view)
    }
}
