//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 28.06.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    var habits: [Habit] {
        HabitsStore.shared.habits
    }
    
    var store = HabitsStore.shared
    let config = UIImage.SymbolConfiguration(pointSize: 40)


    lazy var habitsCollectionView: UICollectionView = {
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
        configurationHabits()
    }

    private func configurationHabits() {
        let buttonAddHabit: UIBarButtonItem = {
            let addHabit = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabits))
            addHabit.tintColor = .systemPurple
            return addHabit
        }()

        navigationController?.navigationBar.tintColor = .systemPurple

        view.addSubview(habitsCollectionView)
        navigationItem.rightBarButtonItem = buttonAddHabit
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true

        NSLayoutConstraint.activate([
            habitsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            habitsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            habitsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            habitsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
 
    @objc func addHabits() {
        let habitViewController = HabitViewController()
        habitViewController.delegateCreate = self
        
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
                cellProgress.delegateProgress = self
            
                cellProgress.progressViewSetProgress(store.todayProgress)
                cellProgress.layer.cornerRadius = 10
                cellProgress.backgroundColor = .white
                return cellProgress
            case 1:
                let cellHabits = collectionView.dequeueReusableCell(withReuseIdentifier: HabitsCollectionCell.identifier, for: indexPath) as! HabitsCollectionCell
                cellHabits.delegate = self
            
                let habitShow = habits[indexPath.row]
                
                cellHabits.configurationSetUp(habit: habitShow)
                cellHabits.buttonStatus.tag = indexPath.item
                cellHabits.layer.cornerRadius = 10
                cellHabits.backgroundColor = .white
    
                return cellHabits
            default:
                let cellDefault = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: indexPath)
                return cellDefault
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
        habitDetailsViewController.indexPath = indexPath
        
        habitDetailsViewController.delegateRemove = self
        habitDetailsViewController.delegateEdit = self
        
        navigationController?.pushViewController(habitDetailsViewController, animated: true)
    }
}

extension HabitsViewController: HabitDetailsViewDelegate, HabitViewDelegeteCreate, HabitEditDelegate, HabitsCollectionCellDelegate {
    
    func didTapStatusButton() {
        let cell = self.habitsCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProgressBarCollectionViewCell
        
        cell?.progressViewSetProgress(self.store.todayProgress)
    }

    func editHabit() {
        self.habitsCollectionView.reloadData()
    }
    
    func createHabit() {
        self.habitsCollectionView.reloadData()
    }
    
    func removeHabit(indexPath: IndexPath) {
        self.store.habits.remove(at: indexPath.item)
//        self.habitsCollectionView.performBatchUpdates {
//            self.habitsCollectionView.deleteItems(at: [indexPath])
//        }
        self.habitsCollectionView.reloadData()
    }
}
