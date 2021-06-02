//
//  DugongFloatingTabViewController.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public class DugongFloatingTabViewController: UIViewController {
    private var headerView: UIView
    private var option: DugongFloatingTabConfiguration
    public var pages: [DugongFloatingTabPageDelegate] = [] {
        didSet {
            addPage(pages: pages)
        }
    }
    public weak var delegate: DugongFloatingTabViewControllerDelegate?

    /// DugongFloatingTabViewController's initializing
    /// - Parameters:
    ///   - pages: Array of VC conformming to DugongFloatingTabPageDelegate protocol
    ///   - headerView: Size-changing top view
    ///   - option: Configuration class including interface option
    public init(pages: [DugongFloatingTabPageDelegate] = [], headerView: UIView, option: DugongFloatingTabConfiguration) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView = headerView
        self.option = option
        self.pageView = DugongFloatingTabPageViewController(pages: pages, option: option)
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
    
    private lazy var floatingTab = DugongFloatingTab(view: headerView, option: option)

    private var pageView: DugongFloatingTabPageViewController

    private func addPage(pages: [DugongFloatingTabPageDelegate]) {
        pageView = DugongFloatingTabPageViewController(pages: pages, option: option)
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.pageViewDelegate = self

        contentView.addSubview(pageView.view)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
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

        view.addSubview(floatingTab)
        NSLayoutConstraint.activate([
            floatingTab.topAnchor.constraint(equalTo: view.topAnchor),
            floatingTab.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            floatingTab.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            floatingTab.heightAnchor.constraint(equalToConstant: option.headerMaxHeight + option.menuTabHeight)
        ])

        floatingTab.menu.delegate = self
        floatingTab.menu.dataSource = self

        // initializing first pageview's scrollview inset and offset
        guard let childVC = pageView.viewControllers?.first as? DugongFloatingTabPageDelegate else { return }
        childVC.delegate = self
        childVC.stickyHeaderChildScrollView?.contentOffset.y = -(option.headerMaxHeight + option.menuTabHeight)
        childVC.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight + option.menuTabHeight, left: 0, bottom: 0, right: 0)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
    }
}

extension DugongFloatingTabViewController: DugongFloatingTabPageScrollDelegate {
    public func childViewScrollViewDidScroll(_ scrollView: UIScrollView) {
        if option.menuTabFixedPosition {
            return
        }
        if scrollView.contentOffset.y == 0 {
            return
        }
        if scrollView.contentOffset.y < 0 {
            for constraint in floatingTab.constraints {
                guard constraint.firstAttribute == .height  else { continue }
                constraint.constant = max(abs(scrollView.contentOffset.y), option.headerMinHeight)
                break
            }
        } else {
            for constraint in floatingTab.constraints {
                guard constraint.firstAttribute == .height else { continue }
                constraint.constant = option.headerMinHeight
                break
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.floatingTab.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension DugongFloatingTabViewController: DugongFloatingTabPageViewControllerDelegate {
    func pageIndexDidChange(index: Int, previous: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = floatingTab.menu.cellForItem(at: IndexPath(item: previous, section: 0))
        cell?.isSelected = false
        
        floatingTab.menu.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        floatingTab.moveSelectedUnderlineView(index: index)
        delegate?.pageIndexDidChange(index: index, previous: previous)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewController.viewControllers?.compactMap({ $0 as? DugongFloatingTabPageDelegate })
            .forEach({ $0.delegate = self })
        delegate?.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers
            .compactMap({ $0 as? DugongFloatingTabPageDelegate })
            .forEach({ $0.stickyHeaderChildScrollView?.contentInset = UIEdgeInsets(top: option.headerMaxHeight + option.menuTabHeight, left: 0, bottom: 0, right: 0) })
        
        pendingViewControllers
            .compactMap({ $0 as? DugongFloatingTabPageDelegate })
            .filter({ $0.stickyHeaderChildScrollView?.contentOffset.y ?? 0 + floatingTab.bounds.height <= (option.headerMaxHeight + option.menuTabHeight) })
            .forEach({ $0.stickyHeaderChildScrollView?.contentOffset.y = -floatingTab.bounds.height })
        delegate?.pageViewController(pageViewController, willTransitionTo: pendingViewControllers)
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
        
        if indexPath.item == 0 {
            cell.isSelected = true
        }

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let direction: UIPageViewController.NavigationDirection = indexPath.item > pageView.visiablePageIndex ? .forward : .reverse
        pageView.pagingTo(toIndex: indexPath.item, navigationDirection: direction, headerViewHeight: floatingTab.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        option.menuTabItemEdgeInsetForSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        option.minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        floatingTab.moveSelectedUnderlineView(index: pageView.visiablePageIndex, animated: false)
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DugongFloatingTabCollectionViewItem else {
            return collectionView.bounds.size
        }
        return CGSize(width: cell.bounds.width, height: collectionView.bounds.height)
    }
}
