//
//  MainScreenViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

/// Контроллер главного меню
final class MainScreenViewController: UIViewController {
	
	@IBOutlet weak var continueGameButton: UIButton!
	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var recordsButton: UIButton!
	
	/// Текущая незаконченная сессия
	var activeSession: GameSession?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkSession()
		setupButtons()
	}

	/// Конфигурирует кнопки
	private func setupButtons() {
		let height = newGameButton.frame.height - 5
		continueGameButton.layer.cornerRadius = height / 2
		newGameButton.layer.cornerRadius = height / 2
		recordsButton.layer.cornerRadius = height / 2
	}
	
	/// Экшн кнопки продолжить игру
	@IBAction func continueTheGame(_ sender: Any) {
		if let vc = self.storyboard?.instantiateViewController(
			withIdentifier: "GameViewController"
		) as? GameViewController,
		   let session = activeSession {
			vc.session = session
			navigationController?.pushViewController(vc, animated: true)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	/// Проверяет на наличие активную сессию игры
	func checkSession() {
		if let session = Game.shared.sessionCaretaker.resumeSession() {
			activeSession = session
			enableContinueButton()
		} else {
			disableContinueButton()
		}
	}
	
	/// Выключает кнопку Продолжить
	func disableContinueButton() {
		continueGameButton.isHidden = true
	}
	
	/// Выключает кнопку Продолжить
	func enableContinueButton() {
		continueGameButton.isHidden = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkSession()
	}
}

