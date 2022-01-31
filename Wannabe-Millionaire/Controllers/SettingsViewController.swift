//
//  SettingsViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 31.01.2022.
//

import UIKit

/// Класс для настройки игры
final class SettingsViewController: UIViewController {

	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	/// Делегат для установки настроек
	weak var delegate: ConfigurableDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupSegmentControl()
    }

	/// Настраивает цвета сегмент контрола
	private func setupSegmentControl() {
		segmentedControl.backgroundColor = .black
		segmentedControl.selectedSegmentTintColor = .white
		segmentedControl.tintColor = .white
		segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .selected)
		segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
		segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
		segmentedControl.selectedSegmentIndex = Game.shared.order.rawValue
	}
	
	/// Выставляем Синглтону настройки по порядку выдачи вопросов. Синглтон - не круто, но такой проект и задание.
	@objc func indexChanged(_ sender: UISegmentedControl) {
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			delegate?.setSettings(order: .successively)
			break
		case 1:
			delegate?.setSettings(order: .random)
			break
		default:
			break
		}
	}

}
