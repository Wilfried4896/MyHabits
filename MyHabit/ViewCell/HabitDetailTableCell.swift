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
    
    lazy var checkmarkBool: UIButton = {
        let checkmar = UIButton()
        checkmar.setImage(UIImage(systemName: "checkmark"), for: .normal)
        checkmar.tintColor = .purple
        checkmar.isHidden = true
        checkmar.translatesAutoresizingMaskIntoConstraints = false
        return checkmar
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
        contentView.addSubview(checkmarkBool)

        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            checkmarkBool.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            checkmarkBool.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            checkmarkBool.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    func configurationData(indexPath: IndexPath) {
        detailLabel.text = HabitsStore.shared.trackDateString(forIndex: HabitsStore.shared.dates.count - 1 - indexPath.item)
        if HabitsStore.shared.habit(HabitsStore.shared.habits[indexPath.item], isTrackedIn: HabitsStore.shared.dates[HabitsStore.shared.dates.count - 1 - indexPath.item]) == true {
            self.checkmarkBool.isHidden = false
        }
    }
}
