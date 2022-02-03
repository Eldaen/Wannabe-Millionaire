//
//  GameViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit
import Foundation

/// Протокол делегата для инициации запуска новой игры
protocol NewGameDelegate: AnyObject {
	func startNewGame()
}

/// Протокол стратегии задания вопросов
protocol QuestionOrderStrategy {
	func loadQuestions(for: GameSession) -> [Question]
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
	@IBOutlet weak var progressLabel: UILabel!
	
	/// Массив вопросов
	var questions: [Question] = []
	
	/// Текущая сессия игры
	var session = GameSession()
	
	/// Стратегия задачи вопросов
	private var questionOrderStrategy: QuestionOrderStrategy {
		switch session.currentQuestionsOrder {
		case .successively:
			return SuccessivelyOrderStrategy()
		case.random:
			return RandomOrderStrategy()
		}
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		observeQuestionCount()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		observeQuestionCount()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		questions = questionOrderStrategy.loadQuestions(for: session)
		
		if session.questionsCount == nil {
			session.questionsCount = questions.count
		}
		
		startTheGame()
		disableUsedClues()
		observeQuestionCount()
		setupProgress()
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
		let question = questions[session.currentQuestionArrayId]
		
		if question.checkAnswer(tag) {
			session.checkQuestionAsAsked(id: question.id)
			
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
	
	/// Запускает игру
	private func startTheGame() {
		let question = questions[session.currentQuestionArrayId]
		session.currentlyAsking(question: question.id)
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
		
		let questionId = session.currentQuestionArrayId
		session.currentlyAsking(question: questions[questionId].id)
		Game.shared.sessionCaretaker.save(session)
		
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
		guard session.hintUsageFacade?.useFiftyFiftyClue() != nil else {
			return
		}
		
		let clue = questions[session.currentQuestionArrayId].fiftyFiftyClue
		
		UIView.animate(withDuration: 0.4) { [weak self] in
			for id in clue {
				self?.answerButtons[id].alpha = 0
				self?.answerButtons[id].isHidden = true
			}
		}
		
		showClueAsUsed(.fiftyFifty)
	}
	
	/// Использовать подсказку Звонок другу
	private func useFriendCallClue() {
		guard session.hintUsageFacade?.useFriendCallClue() != nil else {
			return
		}
		
		let clue = questions[session.currentQuestionArrayId].callFriendClue
		
		UIView.animate(withDuration: 0.4) { [weak self] in
			self?.answerButtons[clue].backgroundColor = .orange
		}
		
		showClueAsUsed(.callFriend)
	}
	
	/// Использовать подсказку Помощь зала
	private func useHallHelpClue() {
		guard session.hintUsageFacade?.useHallHelpClue() != nil else {
			return
		}
		
		let key: Question.HallHelp
		let halfResults: Bool
		var removedResults: [Int] = []
		
		if session.currentQuestionClues.contains(Clues.fiftyFifty.rawValue) {
			key = .half
			halfResults = true
			removedResults = questions[session.currentQuestionArrayId].fiftyFiftyClue
		} else {
			key = .full
			halfResults = false
		}
		
		if let vc = self.storyboard?.instantiateViewController(
			withIdentifier: "HallHelpViewController"
		) as? HallHelpViewController {
			vc.clueData = questions[session.currentQuestionArrayId].getHallHelp(for: key)
			vc.halfResults = halfResults
			vc.removedAnswers = removedResults
			present(vc, animated: true, completion: nil)
		}
		
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
	
	private func observeQuestionCount() {
		session.questionCountNumber.addObserver(self, options: [.new], closure: { [weak self] (number, _) in
			guard let count = self?.session.questionsCount else { return }
			
			let progress = Double(number - 1) / Double(count) * 100
			self?.progressLabel.text = "Вопрос: \(number), Прогресс - \(Int(progress))%"
			self?.progressLabel.layoutIfNeeded()
		})
	}
	
	func setupProgress() {
		guard let count = session.questionsCount else { return }
		
		let progress = Double(session.questionCountNumberInt - 1) / Double(count) * 100
		progressLabel.text = "Вопрос: \(session.questionCountNumberInt), Прогресс - \(Int(progress))%"
		progressLabel.layoutIfNeeded()
	}
}

// MARK: - NewGameDelegate

extension GameViewController: NewGameDelegate {
	func startNewGame() {
		session = GameSession()
		questions = []
		clearCluesButtons()
		
		questions = questionOrderStrategy.loadQuestions(for: session)
		startTheGame()
	}
}
