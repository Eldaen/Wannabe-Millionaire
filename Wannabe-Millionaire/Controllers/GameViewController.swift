//
//  GameViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

/// Протокол делегата для инициации запуска новой игры
protocol NewGameDelegate {
	func startNewGame()
}

/// Основной контроллер игры
final class GameViewController: UIViewController {
	
	@IBOutlet weak var questionTextField: UILabel!
	@IBOutlet var answerButtons: [UIView]!
	@IBOutlet var answerLabels: [UILabel]!
	
	/// Сервис загрузки вопросов
	let questionsService = QuestionsService()
	
	/// Массив вопросов
	var questions: [Question] = []
	
	/// Текущая сессия игры
	var session = GameSession(currentQuestionId: 0, score: 0)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		loadQuestions()
		startTheGame()
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
		}
	}
	
	// MARK: - Private methods
	
	private func checkAnswer(for tag: Int) {
		if questions[session.currentQuestionId].checkAnswer(tag) {
			UIView.animate(withDuration: 0.5) { [weak self] in
				self?.answerButtons[tag - 1].backgroundColor = .green
			} completion: { [weak self] _ in
				UIView.animate(withDuration: 0.5) { [weak self] in
					self?.answerButtons[tag - 1].backgroundColor = .black
				} completion: { [weak self] _ in
						self?.nextQuestion()
				}

			}
		} else {
			UIView.animate(withDuration: 0.5) { [weak self] in
				self?.answerButtons[tag - 1].backgroundColor = .red
			} completion: { [weak self] _ in
				UIView.animate(withDuration: 0.5) { [weak self] in
					self?.answerButtons[tag - 1].backgroundColor = .black
				} completion: { [weak self] _ in
						self?.endGame()
				}

			}
		}
	}
	
	/// Загружает данные вопросов
	private func loadQuestions() {
		questions = questionsService.loadQuestions()
	}
	
	/// Запускает игру
	private func startTheGame() {
		if let question = questions.first {
			displayQuestion(question)
		}
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
			UIView.animate(withDuration: 0.2) { [weak self] in
				self?.questionTextField.text = question.text
				self?.questionTextField.alpha = 1
				
				if let labels = self?.answerLabels.enumerated() {
					for (index, label) in labels {
						label.alpha = 1
						label.text = question.answerOptions[index]
					}
				}
			}
		}
	}
	
	/// Переводит игру к следующему вопросу
	private func nextQuestion() {
		session.nextQuestion()
		session.increaseScore()
		
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
		print("Game over!")
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
}

// MARK: NewGameDelegate

extension GameViewController: NewGameDelegate {
	func startNewGame() {
		session = GameSession(currentQuestionId: 0, score: 0, success: false)
		questions = []
		loadQuestions()
		startTheGame()
	}
}
