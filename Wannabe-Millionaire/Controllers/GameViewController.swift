//
//  GameViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

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
			nextQuestion()
		} else {
			endGame()
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
		questionTextField.text = question.text
		
		for (index, label) in answerLabels.enumerated() {
			label.text = question.answerOptions[index]
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
			endGame()
		}
	}
	
	/// Заканчивает игру
	private func endGame() {
		print("Game over!")
		let record = Record(date: Date(), score: session.score)
		Game.shared.addRecord(record)
		navigationController?.popViewController(animated: true)
	}
}
