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
	
	/// Номер текущего вопроса
	var currentQuestionId: Int = 0

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
	
	private func checkAnswer(for tag: Int) {
		if questions[currentQuestionId].checkAnswer(tag) {
			nextQuestion()
		} else {
			print("Wrong!")
		}
	}
	
	/// Загружает данные вопросов
	private func loadQuestions() {
		questions = questionsService.loadQuestions()
		currentQuestionId = 0
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
		currentQuestionId += 1
		if questions.count > currentQuestionId {
			displayQuestion(questions[currentQuestionId])
		} else {
			endGame()
		}
	}
	
	/// Заканчивает игру
	private func endGame() {
		print("Game over!")
		navigationController?.popViewController(animated: true)
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
