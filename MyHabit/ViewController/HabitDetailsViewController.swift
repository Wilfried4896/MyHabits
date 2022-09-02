//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 09.07.2022.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    var habitIdSelected: Int?
    let habitViewController = HabitViewController()
    let dateDetails = HabitsStore.shared.dates

    lazy var habilDetailView: UITableView = {
        let habilDetail = UITableView()
        habilDetail.register(HabitDetailCell.self, forCellReuseIdentifier: HabitDetailCell.identifier)
        habilDetail.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        habilDetail.delegate = self
        habilDetail.dataSource = self
        habilDetail.backgroundColor = .systemGroupedBackground
        habilDetail.translatesAutoresizingMaskIntoConstraints = false
        return habilDetail
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationHabilDetail()
    }

    private func configurationHabilDetail() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Сделать зарядку"
        self.navigationController?.navigationBar.prefersLargeTitles = false

        view.addSubview(habilDetailView)
        
        let buttonModifiy: UIBarButtonItem = {
            let modifiy = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(modifiyHabit))
            modifiy.tintColor = .systemPurple
            return modifiy
        }()

        navigationItem.rightBarButtonItem = buttonModifiy

        NSLayoutConstraint.activate([
            habilDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habilDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habilDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habilDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc func modifiyHabit() {
        navigationController?.pushViewController(habitViewController, animated: true)
        habitViewController.title = "Править"
        habitViewController.buttonDelete.isHidden = false
        habitViewController.habitIdSelectedShow = habitIdSelected

        let selectedHabit = HabitsStore.shared.habits[habitIdSelected!]
        habitViewController.titleHabitTextField.text = selectedHabit.name
        habitViewController.colorPixel.tintColor = selectedHabit.color
        habitViewController.timeSelected.date = selectedHabit.date
        habitViewController.timeShow.text = "Каждый день: \(selectedHabit.date.formatted(date: .omitted, time: .shortened))"
    }
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellDetail = tableView.dequeueReusableCell(withIdentifier: HabitDetailCell.identifier, for: indexPath) as? HabitDetailCell else {
            let cellDefault = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
            return cellDefault
        }
        let data = dateDetails[indexPath.row]
        //let habitData = HabitsStore.shared.habits[habitIdSelected ?? 0]
        
        return cellDetail
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
}
