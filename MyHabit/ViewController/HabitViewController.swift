//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 28.06.2022.
//

import UIKit

protocol HabitViewDelegeteRemove: AnyObject {
    func removeHabit(indexPath: IndexPath)
}

protocol HabitViewDelegeteCreate: AnyObject {
    func createHabit()
}

class HabitViewController: UIViewController {

    weak var delegateRemove: HabitViewDelegeteRemove?
    weak var delegateCreate: HabitViewDelegeteCreate?
    
    var indexPath: IndexPath?
    var store = HabitsStore.shared
    
    private lazy var nameTextFielLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "НАЗАВИНИЕ"
        nameLabel.font = .systemFont(ofSize: 15, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    lazy var titleHabitTextField: UITextField = {
        let titlehabit = UITextField()
        titlehabit.borderStyle = .none
        titlehabit.placeholder = "Бегать по утрам ..."
        titlehabit.delegate = self
        
        titlehabit.translatesAutoresizingMaskIntoConstraints = false
        return titlehabit
    }()

    private lazy var colorLabel: UILabel = {
        let color = UILabel()
        color.text = "ЦВЕТ"
        color.font = .systemFont(ofSize: 15, weight: .regular)
        color.translatesAutoresizingMaskIntoConstraints = false
        return color
    }()

    lazy var colorPixel: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 40)
        let pixel = UIButton()
        pixel.setImage(UIImage(systemName: "circle.fill", withConfiguration: config), for: .normal)
        pixel.tintColor = .blue
        pixel.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        pixel.translatesAutoresizingMaskIntoConstraints = false
        return pixel
    }()

    private lazy var timeLabel: UILabel = {
        let time = UILabel()
        time.text = "ВРЕМЯ"
        time.font = .systemFont(ofSize: 15, weight: .regular)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()

    lazy var timeShow: UILabel = {
        let show = UILabel()
        show.text = "Каждый день: "
        show.font = .systemFont(ofSize: 20, weight: .regular)
        show.translatesAutoresizingMaskIntoConstraints = false
        return show
    }()

    lazy var timeSelected: UIDatePicker = {
        let selected = UIDatePicker()
        selected.datePickerMode = .time
        selected.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        selected.translatesAutoresizingMaskIntoConstraints = false
        return selected
    }()

    public lazy var buttonDelete: UIButton = {
        let delete = UIButton(type: .system)
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        delete.setTitle("Удалить привычку", for: .normal)
        delete.setTitleColor(UIColor.systemRed, for: .normal)
        delete.addTarget(self, action: #selector(deleteHabitSelected), for: .touchUpInside)
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.isHidden = true
        return delete
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurationHabit()
    }

    private func configurationHabit() {
        let buttonCancel: UIBarButtonItem = {
            let cancel = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancel))
            cancel.tintColor = .systemPurple
            return cancel
        }()

        let buttonCreate: UIBarButtonItem = {
            let create = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(create))
            create.tintColor = .systemPurple
            return create
        }()

        navigationItem.rightBarButtonItem = buttonCreate
        navigationItem.leftBarButtonItem = buttonCancel
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(nameTextFielLabel)
        view.addSubview(titleHabitTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorPixel)
        view.addSubview(timeLabel)
        view.addSubview(timeShow)
        view.addSubview(timeSelected)
        view.addSubview(buttonDelete)


        NSLayoutConstraint.activate([

            // nameTextFielLabelConstraint
            nameTextFielLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameTextFielLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            // titleHabitTextFieldConstraint
            titleHabitTextField.topAnchor.constraint(equalTo: nameTextFielLabel.bottomAnchor, constant: 10),
            titleHabitTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleHabitTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

            // colorLabelConstraint
            colorLabel.topAnchor.constraint(equalTo: titleHabitTextField.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            // colorPixelConstraint
            colorPixel.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            colorPixel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            // timeLabelConstraint
            timeLabel.topAnchor.constraint(equalTo: colorPixel.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            // timeShowConstraint
            timeShow.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            timeShow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            // timeSelectedConstraint
            timeSelected.topAnchor.constraint(equalTo: timeShow.bottomAnchor, constant: 10),
            timeSelected.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            // buttonDeleteConstraint
            buttonDelete.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonDelete.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }

    @objc func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }
     
    @objc func create() {
        
        if buttonDelete.isHidden == false {
            
            guard let indexPath = self.indexPath else {
                print(#function)
                return
            }
            
            let editHabit = Habit(name: titleHabitTextField.text ?? "NO DATA",
                                  date: timeSelected.date,
                                  color: colorPixel.tintColor)
            editHabit.trackDates = self.store.habits[indexPath.item].trackDates
            self.store.habits[indexPath.item] = editHabit
        }

        else {
            let newHabit = Habit(name: titleHabitTextField.text ?? "NO DATA",
                                     date: timeSelected.date,
                                     color: colorPixel.tintColor)

            self.store.habits.append(newHabit)
        }
        
        self.delegateCreate?.createHabit()
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func changeColor() {
        pixelColor()
    }

    @objc func changeValue() {
        let date = DateFormatter()
        date.dateFormat = "HH : mm"
        timeShow.text = "Каждый день: \(date.string(from: timeSelected.date))"
    }

    func pixelColor() {
        let color = UIColorPickerViewController()
        color.delegate = self
        color.selectedColor = colorPixel.tintColor
        color.title = "Выбирайте цвет"
        present(color, animated: true, completion: nil)
    }

    @objc func deleteHabitSelected() {
        
        guard let indexPath = self.indexPath else {
            return
        }

        let messageAlert = UIAlertController(title: "Удалить привычку", message: "Хотите удалить привычку \(HabitsStore.shared.habits[indexPath.row].name)", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }

        let delete = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            self.dismiss(animated: true) {
                self.delegateRemove?.removeHabit(indexPath: indexPath)
            }
        }
        
        messageAlert.addAction(cancel)
        messageAlert.addAction(delete)
        
        present(messageAlert, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate, UITextFieldDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorPixel.tintColor = viewController.selectedColor
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    }
}
