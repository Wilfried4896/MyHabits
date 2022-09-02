//
//  TableViewController.swift
//  MyHabits
//
//  Created by Вилфриэд Оди on 28.06.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = UINavigationBarAppearance()
        navigationBar.configureWithOpaqueBackground()
        navigationBar.backgroundColor = .white
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBar

        let tabBar = UITabBarAppearance()
        tabBar.configureWithOpaqueBackground()
        tabBar.backgroundColor = .white
        UITabBar.appearance().scrollEdgeAppearance = tabBar

        configuration()
    }

    private func configuration() {

        let infoViewController: UINavigationController = {
            let info = UINavigationController(rootViewController: InfoViewController())
            info.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
            return info
        }()

        let habitsViewController: UINavigationController = {
            let habits = UINavigationController(rootViewController: HabitsViewController())
            habits.tabBarItem = UITabBarItem(title: "Привычка", image: UIImage(systemName: "rectangle.grid.1x2.fill"), tag: 0)
            return habits
        }()

        setViewControllers([habitsViewController, infoViewController], animated: true)
        UITabBar.appearance().tintColor = UIColor.systemPurple
    }
}
