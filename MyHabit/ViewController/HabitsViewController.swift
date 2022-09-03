//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 28.06.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    let habits: [Habit] = HabitsStore.shared.habits
    let config = UIImage.SymbolConfiguration(pointSize: 40)


    lazy var habitsCollectionCell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 15, right: 5)
        layout.scrollDirection = .vertical
        let habitsCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        habitsCollection.register(HabitsCollectionCell.self, forCellWithReuseIdentifier: HabitsCollectionCell.identifier)
        habitsCollection.register(ProgressBarCollectionViewCell.self, forCellWithReuseIdentifier: ProgressBarCollectionViewCell.identifier)
        habitsCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Default")
        habitsCollection.delegate = self
        habitsCollection.dataSource = self
        habitsCollection.clipsToBounds = true
        habitsCollection.backgroundColor = .systemGroupedBackground
        habitsCollection.translatesAutoresizingMaskIntoConstraints = false
        return habitsCollection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        configurationHabits()
    }

    private func configurationHabits() {
        let buttonAddHabit: UIBarButtonItem = {
            let addHabit = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabits))
            addHabit.tintColor = .systemPurple
            return addHabit
        }()

        navigationController?.navigationBar.tintColor = .systemPurple

        view.addSubview(habitsCollectionCell)
        navigationItem.rightBarButtonItem = buttonAddHabit
        view.backgroundColor = .systemGroupedBackground

        NSLayoutConstraint.activate([
            habitsCollectionCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            habitsCollectionCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            habitsCollectionCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            habitsCollectionCell.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func addHabits() {
        let habitViewController = HabitViewController()
        habitViewController.navigationItem.title = "Создать"
        navigationController?.pushViewController(habitViewController, animated: true)
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return habits.count
            default:
                return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                let cellProgress = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressBarCollectionViewCell.identifier, for: indexPath) as! ProgressBarCollectionViewCell
                cellProgress.configurationProgressView()
                cellProgress.layer.cornerRadius = 10
                cellProgress.backgroundColor = .white
                return cellProgress
            case 1:
                let cellHabits = collectionView.dequeueReusableCell(withReuseIdentifier: HabitsCollectionCell.identifier, for: indexPath) as! HabitsCollectionCell
                let habitShow = habits[indexPath.row]
                cellHabits.configurationSetUp(habit: habitShow)
                if habitShow.isAlreadyTakenToday {
                    cellHabits.buttonStatus.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: config), for: .normal)
                }
                cellHabits.buttonStatus.addTarget(self, action: #selector(didSelected(_ :)), for: .touchUpInside)
                cellHabits.buttonStatus.tag = indexPath.item
                cellHabits.layer.cornerRadius = 10
                cellHabits.backgroundColor = .white
                return cellHabits
            default:
                let cellDefault = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: indexPath)
                return cellDefault
            }
        }
    
        @objc func didSelected(_ sender: UIButton) {
            let habit = habits[sender.tag]
            if !habit.isAlreadyTakenToday {
                sender.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: config), for: .normal)
                HabitsStore.shared.track(habit)
            }
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let widthcollectionView = collectionView.frame.width - sectionInset.left - sectionInset.right
        return indexPath.section == 0 ? CGSize(width: widthcollectionView, height: 75) : CGSize(width: widthcollectionView, height: 150)

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let habitDetailsViewController = HabitDetailsViewController()
        habitDetailsViewController.habitIdSelected = indexPath.row
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }

}
