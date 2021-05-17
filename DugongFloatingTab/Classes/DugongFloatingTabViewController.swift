//
//  DugongFloatingTabViewController.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public class DugongFloatingTabViewController: UIViewController {
    private var headerView: UIView
    private var pages: [DugongFloatingTabPageDelegate]
    private var option: DugongFloatingTabConfiguration
    private var isSelectedItem: [Bool]

    /// DugongFloatingTabViewController's initializing
    /// - Parameters:
    ///   - pages: Array of VC conformming to DugongFloatingTabPageDelegate protocol
    ///   - headerView: Size-changing top view
    ///   - option: Configuration class including interface option
    public init(pages: [DugongFloatingTabPageDelegate], headerView: UIView, option: DugongFloatingTabConfiguration) {
        self.pages = pages
        self.headerView = headerView
        self.option = option
        self.isSelectedItem = [Bool](repeating: false, count: pages.count)
        self.isSelectedItem[0] = true
        super.init(nibName: nil, bundle: nil)
        configuration(option: option)
    }
    
    private func configuration(option: DugongFloatingTabConfiguration) {
        contentView.backgroundColor = option.contentViewBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stickyHeaderView = DugongFloatingTab(view: headerView, option: option)
    
    private lazy var pageView: DugongFloatingTabPageViewController = {
        let pageView = DugongFloatingTabPageViewController(pages: pages, option: option)
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.pageViewDelegate = self
        return pageView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.autoresizingMask = [.flexibleRightMargin, .flexibleHeight]
        contentView.addSubview(pageView.view)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        }
        
        addChild(pageView)
        pageView.didMove(toParent: self)
        NSLayoutConstraint.activate([
            pageView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pageView.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageView.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageView.view.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        view.addSubview(stickyHeaderView)
        NSLayoutConstraint.activate([
            stickyHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            stickyHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyHeaderView.heightAnchor.constraint(equalToConstant: option.headerMaxHeight)
        ])
        
        stickyHeaderView.menu.delegate = self
        stickyHeaderView.menu.dataSource = self
        
        // initializing first pageview's scrollview inset and offset
        guard let childVC = pageView.viewControllers?.first as? DugongFloatingTabPageDelegate else { return }
        childVC.delegate = self
        childVC.stickyHeaderChildScrollView?.contentOffset.y = -(option.headerMaxHeight + option.menuTabHeight)
        childVC.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight + option.menuTabHeight, left: 0, bottom: 0, right: 0)
    }
}

extension DugongFloatingTabViewController: DugongFloatingTabPageScrollDelegate {
    public func childViewScrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            return
        }
        if scrollView.contentOffset.y < 0 {
            for constraint in stickyHeaderView.constraints {
                guard constraint.firstAttribute == .height  else { continue }
                constraint.constant = max(abs(scrollView.contentOffset.y), option.headerMinHeight)
                break
            }
        } else {
            for constraint in stickyHeaderView.constraints {
                guard constraint.firstAttribute == .height else { continue }
                constraint.constant = option.headerMinHeight
                break
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.stickyHeaderView.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension DugongFloatingTabViewController: DugongFloatingTabPageViewControllerDelegate {
    func pageIndexDidChange(index: Int) {
        isSelectedItem = stickyHeaderView.selectedItemHighligt(index: index, isSelectedItem: isSelectedItem)
        stickyHeaderView.moveSelectedUnderlineView(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewController.viewControllers?.compactMap({ $0 as? DugongFloatingTabPageDelegate })
            .forEach({ $0.delegate = self })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers
            .compactMap({ $0 as? DugongFloatingTabPageDelegate })
            .forEach({ $0.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight + option.menuTabHeight, left: 0, bottom: 0, right: 0) })
        
        pendingViewControllers
            .compactMap({ $0 as? DugongFloatingTabPageDelegate })
            .filter({ $0.stickyHeaderChildScrollView?.contentOffset.y ?? 0 + stickyHeaderView.bounds.height <= (option.headerMaxHeight + option.menuTabHeight) })
            .forEach({ $0.stickyHeaderChildScrollView?.contentOffset.y = -stickyHeaderView.bounds.height })
    }
}

extension DugongFloatingTabViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DugongFloatingTabCollectionViewItem.identifier, for: indexPath) as? DugongFloatingTabCollectionViewItem else {
            return UICollectionViewCell()
        }

        cell.setupUI(title: pages[indexPath.row].title, option: option)
        cell.update(isSelected: isSelectedItem[indexPath.item], option: option)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let direction: UIPageViewController.NavigationDirection = indexPath.item > pageView.visiablePageIndex ? .forward : .reverse
        pageView.pagingTo(toIndex: indexPath.item, navigationDirection: direction, headerViewHeight: stickyHeaderView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        option.menuTabItemEdgeInsetForSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        option.minimumLineSpacing
    }

//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        isSelectedItem = stickyHeaderView.selectedItemHighligt(index: pageView.visiablePageIndex, isSelectedItem: isSelectedItem)
//        stickyHeaderView.moveSelectedUnderlineView(index: pageView.visiablePageIndex, animated: false)
//        return .zero
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? DugongFloatingTabCollectionViewItem else {
//            return collectionView.bounds.size
//        }
//        return CGSize(width: cell.bounds.width, height: collectionView.bounds.height)
//    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        isSelectedItem = stickyHeaderView.selectedItemHighligt(index: indexPath.item, isSelectedItem: isSelectedItem)
        return true
    }
}
