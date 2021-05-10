//
//  FloatingTab.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

public class FloatingTab: UIView {
    private let option: DugongFloatingTabConfiguration

    private var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var selectedUnderlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var menu: UICollectionView = {
        let layout = FloatingTabCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        if #available(iOS 10.0, *) {
            layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        } else {
            // Fallback on earlier versions
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FloatingTabCollectionViewItem.self,
                                forCellWithReuseIdentifier: FloatingTabCollectionViewItem.identifier)
        collectionView.backgroundColor = option.menuTabBackgroundColor
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
        }
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    public init(view: UIView, option: DugongFloatingTabConfiguration) {
        self.option = option
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
        headerView.addSubview(view)
        self.addSubview(menu)
        self.clipsToBounds = true
        NSLayoutConstraint.activate([
            menu.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menu.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menu.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menu.heightAnchor.constraint(lessThanOrEqualToConstant: option.menuTabHeight)
        ])

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: menu.topAnchor)
        ])

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: headerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: menu.topAnchor)
        ])

        selectedUnderlineView.backgroundColor = option.selectedMenuTabItemUnderlineColor
        self.addSubview(selectedUnderlineView)
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let cell = menu.cellForItem(at: IndexPath(item: 0, section: 0)) as? FloatingTabCollectionViewItem else {
            return
        }
        NSLayoutConstraint.activate([
            selectedUnderlineView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            selectedUnderlineView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            selectedUnderlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedUnderlineView.heightAnchor.constraint(equalToConstant: option.selectedMenuTabItemUnderlineHeight),
        ])
    }

    func moveSelectedUnderlineView(index: Int, animated: Bool = true) {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = menu.cellForItem(at: indexPath) as? FloatingTabCollectionViewItem else {
            return
        }
        menu.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedUnderlineView.removeFromSuperview()
        self.addSubview(selectedUnderlineView)
        NSLayoutConstraint.activate([
            selectedUnderlineView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            selectedUnderlineView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            selectedUnderlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            selectedUnderlineView.heightAnchor.constraint(equalToConstant: option.selectedMenuTabItemUnderlineHeight),
        ])

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            super.setNeedsLayout()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
