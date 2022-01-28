//
//  GameViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit
import Foundation

/// Протокол делегата для инициации запуска новой игры
protocol NewGameDelegate {
	func startNewGame()
}

/// Основной контроллер игры
final class GameViewController: UIViewController {
	
	/// Типы подсказок
	enum Clues: Int {
		case fiftyFifty = 0
		case callFriend = 1
		case hallHelp = 2
	}
	
	@IBOutlet var clueCollection: [UIView]!
	@IBOutlet weak var questionTextField: UILabel!
	@IBOutlet var answerButtons: [UIView]!
	@IBOutlet var answerLabels: [UILabel]!
	
	/// Сервис загрузки вопросов
	let questionsService = QuestionsService()
	
	/// Массив вопросов
	var questions: [Question] = []
	
	/// Текущая сессия игры
	var session = GameSession()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		loadQuestions()
		startTheGame()
		disableUsedClues()
    }
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let firstTouch = touches.first {
			let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)

			for button in answerButtons {
				if hitView == button {
					checkAnswer(for: button.tag)
					break
				}
			}
			
			for clue in clueCollection {
				if hitView == clue {
					if let clueName = Clues(rawValue: clue.tag) {
						useClue(for: clueName)
					}
					break
				}
			}
			
			Game.shared.sessionCaretaker.save(session)
		}
	}
	
	// MARK: - Private methods
	
	/// Проверяет правильность ответа
	private func checkAnswer(for tag: Int) {
		if questions[session.currentQuestionId].checkAnswer(tag) {
			animateAnswer(for: tag, result: true) { [weak self] in
				self?.cleanClues()
				self?.nextQuestion()
			}
		} else {
			animateAnswer(for: tag, result: false) { [weak self] in
				self?.endGame()
			}
		}
	}
	
	/// Анимирует  ответ
	private func animateAnswer(for id: Int, result: Bool, completion: @escaping () -> Void) {
		UIView.animate(withDuration: 0.5) { [weak self] in
			self?.answerButtons[id].backgroundColor = result ? .green : .red
		} completion: { [weak self] _ in
			UIView.animate(withDuration: 0.5) { [weak self] in
				self?.answerButtons[id].backgroundColor = .black
			} completion: { _ in
				completion()
			}
		}
	}
	
	/// Загружает данные вопросов
	private func loadQuestions() {
		questions = questionsService.loadQuestions()
	}
	
	/// Запускает игру
	private func startTheGame() {
		let question = questions[session.currentQuestionId]
		displayQuestion(question)
	}
	
	/// Заполняет поля вопроса
	private func displayQuestion(_ question: Question) {
		UIView.animate(withDuration: 0.4) { [weak self] in
			self?.questionTextField.alpha = 0
			
			if let labels = self?.answerLabels {
				for label in labels {
					label.alpha = 0
				}
			}
		} completion: { [weak self] _ in
			UIView.animate(withDuration: 0.2, delay: 0.2) { [weak self] in
				self?.questionTextField.text = question.text
				self?.questionTextField.alpha = 1
			} completion: { [weak self] _ in
				UIView.animate(withDuration: 0.3) {
					if let labels = self?.answerLabels.enumerated() {
						for (index, label) in labels {
							label.alpha = 1
							label.text = question.answerOptions[index]
						}
					}
				}
			}
		}
	}
	
	/// Переводит игру к следующему вопросу
	private func nextQuestion() {
		session.nextQuestion()
		session.increaseScore()
		Game.shared.sessionCaretaker.save(session)
		
		let questionId = session.currentQuestionId
		
		if questions.count > questionId {
			displayQuestion(questions[questionId])
		} else {
			session.didWin()
			endGame()
		}
	}
	
	/// Заканчивает игру
	private func endGame() {
		let record = Record(date: Date(), score: session.score)
		Game.shared.addRecord(record)
		
		if let vc = self.storyboard?.instantiateViewController(
			withIdentifier: "ResultViewController"
		) as? ResultViewController {
			vc.success = session.success
			vc.score = session.score
			vc.delegate = self
			navigationController?.pushViewController(vc, animated: true)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	/// Использует подсказку
	private func useClue(for clue: Clues) {
		switch clue {
		case .fiftyFifty:
			useFiftyFiftyClue()
		case .callFriend:
			useFriendCallClue()
		case .hallHelp:
			useHallHelpClue()
		}
	}
	
	/// Использовать подсказку 50 на 50
	private func useFiftyFiftyClue() {
		guard !session.usedClues.contains(Clues.fiftyFifty.rawValue) else {
			return
		}
		
		let clue = questions[session.currentQuestionId].fiftyFiftyClue
		
		UIView.animate(withDuration: 0.4) { [weak self] in
			for id in clue {
				self?.answerButtons[id].alpha = 0
				self?.answerButtons[id].isHidden = true
			}
		}
		session.usedClues.append(Clues.fiftyFifty.rawValue)
		session.currentQuestionClues.append(Clues.fiftyFifty.rawValue)
		showClueAsUsed(.fiftyFifty)
	}
	
	/// Использовать подсказку Звонок другу
	private func useFriendCallClue() {
		guard !session.usedClues.contains(Clues.callFriend.rawValue) else {
			return
		}
		
		let clue = questions[session.currentQuestionId].callFriendClue
		
		UIView.animate(withDuration: 0.4) { [weak self] in
			self?.answerButtons[clue].backgroundColor = .orange
		}
		session.usedClues.append(Clues.callFriend.rawValue)
		session.currentQuestionClues.append(Clues.callFriend.rawValue)
		showClueAsUsed(.callFriend)
	}
	
	/// Использовать подсказку Помощь зала
	private func useHallHelpClue() {
		guard !session.currentQuestionClues.contains(Clues.hallHelp.rawValue) else {
			return
		}
		
		let key: Question.HallHelp
		let halfResults: Bool
		var removedResults: [Int] = []
		
		if session.currentQuestionClues.contains(Clues.fiftyFifty.rawValue) {
			key = .half
			halfResults = true
			removedResults = questions[session.currentQuestionId].fiftyFiftyClue
		} else {
			key = .full
			halfResults = false
		}
		
		if let vc = self.storyboard?.instantiateViewController(
			withIdentifier: "HallHelpViewController"
		) as? HallHelpViewController {
			vc.clueData = questions[session.currentQuestionId].getHallHelp(for: key)
			vc.halfResults = halfResults
			vc.removedAnswers = removedResults
			present(vc, animated: true, completion: nil)
		}
		
		session.usedClues.append(Clues.hallHelp.rawValue)
		session.currentQuestionClues.append(Clues.hallHelp.rawValue)
		showClueAsUsed(.hallHelp)
	}
	
	/// Убрать изменения интерфейса, которые сделали подсказки
	private func cleanClues() {
		for clue in session.currentQuestionClues {
			if let clue = Clues(rawValue: clue) {
				
				switch clue {
				case .fiftyFifty:
					UIView.animate(withDuration: 0.4) { [weak self] in
						if let buttons = self?.answerButtons {
							for button in buttons {
								button.alpha = 1
								button.isHidden = false
							}
						}
					}
				case .callFriend:
					UIView.animate(withDuration: 0.4) { [weak self] in
						if let buttons = self?.answerButtons {
							for button in buttons {
								button.backgroundColor = .black
							}
						}
					}
				case .hallHelp:
					return
				}
			}
		}
	}
	
	private func showClueAsUsed(_ clue: Clues) {
		if let image = clueCollection[clue.rawValue].subviews.first {
			image.tintColor = .red
		}
	}
	
	/// Возвращает цвет подсказок к обычному
	private func clearCluesButtons() {
		for clue in clueCollection {
			if let image = clue.subviews.first {
				image.tintColor = .white
			}
		}
	}
	
	/// Отмечает подсказки как использованные после загрузки сессии
	private func disableUsedClues() {
		for clue in session.usedClues {
			if let clue = Clues(rawValue: clue) {
				showClueAsUsed(clue)
			}
		}
	}
}

// MARK: NewGameDelegate

extension GameViewController: NewGameDelegate {
	func startNewGame() {
		session = GameSession()
		questions = []
		clearCluesButtons()
		
		loadQuestions()
		startTheGame()
	}
}
