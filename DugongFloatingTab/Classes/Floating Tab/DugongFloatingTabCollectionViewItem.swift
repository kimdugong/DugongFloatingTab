//
//  DugongFloatingTabCollectionViewItem.swift
//  DugongFloatingTab
//
//  Created by Dugong on 2021/05/10.
//

import UIKit

class DugongFloatingTabCollectionViewItem: UICollectionViewCell {
    static let identifier = "DugongFloatingTabCollectionViewItem"
    private var option: DugongFloatingTabConfiguration?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
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

    private func config() {
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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2.5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2.5)
        ])
    }
    
    func setupUI(title: String?, option: DugongFloatingTabConfiguration) {
        self.option = option
        contentView.backgroundColor = option.menuTabItemBackgroundColor
        titleLabel.text = title
        titleLabel.textColor = option.menuTabItemLabelTextColor
        titleLabel.font = option.menuTabItemLabelFont
        titleLabel.sizeToFit()
    }

    func update(isSelected: Bool, option: DugongFloatingTabConfiguration) {
        if isSelected {
            titleLabel.textColor = option.menuTabSeletedItemLabelTextColor
            titleLabel.font = option.menuTabSelectedItemLabelFont
        }
        else {
            titleLabel.textColor = option.menuTabItemLabelTextColor
            titleLabel.font = option.menuTabItemLabelFont
        }
    }
    
}
