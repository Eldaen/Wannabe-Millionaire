//
//  ResultViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 27.01.2022.
//

import UIKit

/// Контроллер для отображения результатов игры
final class ResultViewController: UIViewController {
	
	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	
	/// Результат игры
	var success: Bool = false
	
	/// Счёт
	var score: Int = 0
	
	/// Делегат перезапуска игры
	weak var delegate: NewGameDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		displayResult()
		navigationController?.isNavigationBarHidden = true
    }
	
	/// Выводит сообщение окончания игры
	private func displayResult() {
		Game.shared.sessionCaretaker.clearSession()
		
		if success {
			resultLabel.text = "Поздравляю, вы победили!"
		} else {
			resultLabel.text = "Игра окончена, попробуйте ещё раз и всё получится!"
		}
		scoreLabel.text = String(self.score)
	}
	
	/// Выходим в главное меню
	@IBAction func goToMainMenu(_ sender: Any) {
		navigationController?.isNavigationBarHidden = false
		navigationController?.popToRootViewController(animated: true)
	}
	
	/// Запускаем новую игру
	@IBAction func startNewGame(_ sender: Any) {
		delegate?.startNewGame()
		navigationController?.isNavigationBarHidden = false
		navigationController?.popViewController(animated: true)
	}
}
