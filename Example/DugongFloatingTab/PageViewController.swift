//
//  PageViewController.swift
//  DugongFloatingTab_Example
//
//  Created by Dugong on 2021/05/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DugongFloatingTab

class PageViewController: UIViewController, DugongFloatingTabPageDelegate {
    @IBOutlet weak var tableView: UITableView!
    var stickyHeaderChildScrollView: UIScrollView?
    var pageIndex: Int = 0
    weak var option: DugongFloatingTabConfiguration?
    weak var delegate: DugongFloatingTabPageScrollDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false

        // assign your scroll view for me to handle offset, inset when change page view controller
        stickyHeaderChildScrollView = tableView
    }
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(title ?? "") row : \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        option?.headerMaxHeight = CGFloat(100 * indexPath.row)
//        delegate?.reloadFloatingTabPage()
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        parent?.parent?.parent?.navigationController?.pushViewController(vc, animated: true)
    }

    // delegate me for floating tab
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.childViewScrollViewDidScroll(scrollView)
    }

}
