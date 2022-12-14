//
//  HabitsCollectionCell.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 29.06.2022.
//

import UIKit

protocol HabitsCollectionCellDelegate: AnyObject {
    func didTapStatusButton()
}

class HabitsCollectionCell: UICollectionViewCell {
    static let identifier: String = "HabitsCollectionCell"
    weak var delegate: HabitsCollectionCellDelegate?
    
    let config = UIImage.SymbolConfiguration(pointSize: 40)

    lazy var headlineLabel: UILabel = {
        let headline = UILabel()
        headline.numberOfLines = 2
        headline.font = .systemFont(ofSize: 17, weight: .semibold)
        headline.translatesAutoresizingMaskIntoConstraints = false
        return headline
    }()

    lazy var bodyLabel: UILabel = {
        let body = UILabel()
        body.font = .systemFont(ofSize: 17, weight: .regular)
        body.textColor = .systemGray
        body.translatesAutoresizingMaskIntoConstraints = false
        return body
    }()

    lazy var footNoteLabel: UILabel = {
        let footnote = UILabel()
        footnote.font = .systemFont(ofSize: 15, weight: .semibold)
        footnote.textColor = .systemGray
        footnote.translatesAutoresizingMaskIntoConstraints = false
        return footnote
    }()

    lazy var buttonStatus: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "circle", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_ :)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configurationHabitsCollectionCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        headlineLabel.text = nil
        bodyLabel.text = nil
        footNoteLabel.text = nil
        buttonStatus.tintColor = nil
    }

    private func configurationHabitsCollectionCell() {
        contentView.addSubview(headlineLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(footNoteLabel)
        contentView.addSubview(buttonStatus)

        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            headlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -CGFloat(contentView.frame.width * 0.35)),

            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 7),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),

            footNoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            footNoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            //footNoteLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 30),

            buttonStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            buttonStatus.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configurationSetUp(habit: Habit) {
        headlineLabel.text = habit.name
        bodyLabel.text = habit.dateString
        footNoteLabel.text = "Счетчик: \(habit.trackDates.count)"
        headlineLabel.tintColor = habit.color
        buttonStatus.tintColor = habit.color
        headlineLabel.textColor = habit.color
        
        guard habit.isAlreadyTakenToday == true  else {
            buttonStatus.setImage(UIImage(systemName: "circle", withConfiguration: config), for: .normal)
            return
            
        }
            buttonStatus.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: config), for: .normal)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        
        let habit = HabitsStore.shared.habits[sender.tag]
        
        print(HabitsStore.shared.habits.count)
        if habit.isAlreadyTakenToday == false {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: config), for: .normal)
        }
        
        
        
        HabitsStore.shared.track(habit)
        footNoteLabel.text = "Счетчик: \(habit.trackDates.count)"
        self.delegate?.didTapStatusButton()
    }
}
