//
//  FloatingTabCollectionViewItem.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

class FloatingTabCollectionViewItem: UICollectionViewCell {
    static let identifier = "StickyMenuCollectionViewCell"

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var selectedUnderlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func setupUI(title: String?, option: DugongFloatingTabConfiguration) {
        contentView.backgroundColor = option.menuTabItemBackgroundColor
        titleLabel.text = title
        titleLabel.font = option.menuTabItemLabelFont
        titleLabel.textColor = option.menuTabItemLabelTextColor
        titleLabel.sizeToFit()
    }

}
