//
//  MainScreenViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

/// Протокол для установки настроек
protocol ConfigurableDelegate: AnyObject {
	
	/// Передаёт настройки игры
	func setSettings(order: Game.QuestionsOrder)
}

/// Контроллер главного меню
final class MainScreenViewController: UIViewController {
	
	@IBOutlet weak var continueGameButton: UIButton!
	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var recordsButton: UIButton!
	@IBOutlet weak var stackView: UIStackView!
	
	/// Текущая незаконченная сессия
	var activeSession: GameSession?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		checkSession()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkSession()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SettingsController" {
			if let vc = segue.destination as? SettingsViewController {
				vc.delegate = self
			}
		}
	}
	
	/// Экшн кнопки продолжить игру
	@IBAction func continueTheGame(_ sender: Any) {
		if let vc = self.storyboard?.instantiateViewController(
			withIdentifier: "GameViewController"
		) as? GameViewController,
		   let session = activeSession {
			session.resetArrayCount()
			vc.session = session
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	/// Проверяет на наличие активную сессию игры
	func checkSession() {
		if let session = Game.shared.sessionCaretaker.resumeSession() {
			activeSession = session
			setContinueButton(state: .on)
		} else {
			setContinueButton(state: .off)
		}
	}
	
	/// Выключает кнопку Продолжить
	func setContinueButton(state: ContinueButtonState) {
		continueGameButton.isHidden = state.bool
	}
}

// MARK: - ConfigurableDelegate

extension MainScreenViewController: ConfigurableDelegate {
	func setSettings(order: Game.QuestionsOrder) {
		
		// Настройки будут меняться, только если нет активной игры
		guard Game.shared.sessionCaretaker.resumeSession() == nil else { return }
		Game.shared.order = order
	}
}

