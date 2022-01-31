//
//  MainScreenViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

/// Контроллер главного меню
final class MainScreenViewController: UIViewController {
	
	/// Состояния кнопки ПРОДОЛЖИТЬ
	enum ContinueButtonState {
		case on
		case off
		
		var bool: Bool {
			switch self {
			case .off:
				return true
			default:
				return false
			}
		}
	}
	
	@IBOutlet weak var continueGameButton: UIButton!
	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var recordsButton: UIButton!
	@IBOutlet weak var stackView: UIStackView!
	
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
		_ = stackView.subviews.map { $0.layer.cornerRadius = height / 2	}
	}
	
	/// Экшн кнопки продолжить игру
	@IBAction func continueTheGame(_ sender: Any) {
		if let vc = self.storyboard?.instantiateViewController(
			withIdentifier: "GameViewController"
		) as? GameViewController,
		   let session = activeSession {
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkSession()
	}
}

