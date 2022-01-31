//
//  SettingsViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 31.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet weak var segmentControl: UISegmentedControl!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupSegmentControl()

        // Do any additional setup after loading the view.
    }
    

	/// Настраивает цвета сегмент контрола
	private func setupSegmentControl() {
		segmentControl.backgroundColor = .black
		segmentControl.selectedSegmentTintColor = .white
		segmentControl.tintColor = .white
		segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .selected)
		segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
	}

}
