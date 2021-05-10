//
//  PageViewController.swift
//  DugongFloatingTab_Example
//
//  Created by Dugong on 2021/05/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DugongFloatingTab

class PageViewController: UIViewController, DugongFloatingTabPageDelegate{
    @IBOutlet weak var tableView: UITableView!
    var stickyHeaderChildScrollView: UIScrollView?
    var pageIndex: Int = 0
    weak var delegate: DugongFloatingTabPageScrollDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)

        // assign your scroll view for me to handle offset, inset when change page view controller
        stickyHeaderChildScrollView = tableView
    }
}

extension PageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(title ?? "") row : \(indexPath.row)"
        return cell
    }

    // delegate me for sticky header view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.childViewScrollViewDidScroll(scrollView)
    }

}
