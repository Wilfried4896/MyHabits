//
//  HabitDetailTableView.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 09.07.2022.
//

import UIKit

class HabitDetailCell: UITableViewCell {

    static let identifier: String = "HabitDetailCell"
    let config = UIImage.SymbolConfiguration(pointSize: 40)
    
    lazy var detailLabel: UILabel = {
        let detail = UILabel()
        detail.translatesAutoresizingMaskIntoConstraints = false
        return detail
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configurationDetailCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        detailLabel.text = nil
    }

    private func configurationDetailCell() {
        contentView.addSubview(detailLabel)
        //contentView.addSubview(checkmarkBool)

        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

//            checkmarkBool.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor),
//            checkmarkBool.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            checkmarkBool.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        ])
    }

    func configurationData(index: Int) {
        detailLabel.text = HabitsStore.shared.trackDateString(forIndex: index)
        //detailLabel.text = habit.name
    }
}
