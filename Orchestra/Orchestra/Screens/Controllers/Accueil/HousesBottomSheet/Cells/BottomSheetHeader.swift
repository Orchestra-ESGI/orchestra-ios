//
//  BottomSheetHeader.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 07/05/2021.
//

import UIKit

class BottomSheetHeader: UITableViewHeaderFooterView {
    let title = UILabel()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configureContents() {
        title.font = UIFont.boldSystemFont(ofSize: 35.0)
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
                   constant: 10),
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15.0)
        ])
    }
}
