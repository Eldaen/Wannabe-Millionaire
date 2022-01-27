//
//  ViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

/// Контроллер главного меню
final class MainScreenViewController: UIViewController {
	
	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var recordsButton: UIButton!
	
	
	@IBAction func newGame(_ sender: UIButton) {
	}
	@IBAction func showRecords(_ sender: UIButton) {
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButtons()
	}

	private func setupButtons() {
		let height = newGameButton.frame.height - 5
		newGameButton.layer.cornerRadius = height / 2
		recordsButton.layer.cornerRadius = height / 2
	}

}

