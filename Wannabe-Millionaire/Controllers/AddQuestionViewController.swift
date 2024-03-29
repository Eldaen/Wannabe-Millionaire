//
//  AddQuestionViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import UIKit

/// Контроллер добавления вопросов в игру
final class AddQuestionViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	/// Кол-во форм для вопросов
	var formsCount: Int = 1
	
	/// Кол-во секций в таблице
	let sectionsCount = 1
	
	/// Caretaker для сохранения пользовательских вопросов
	let caretaker = QuestionsCaretaker(key: "questions")
	
	/// Билдер массива введённых пользователем вопросов
	let builder = AddQuestionsBuilder()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configureTableView()
    }
	
	private func configureTableView() {
		tableView.dataSource = self
		tableView.backgroundColor = .black
		tableView.separatorColor = .blue
		tableView.register(UINib(nibName: "AddQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "AddQuestionTableViewCell")
	}
	
	@IBAction func addQuestionForm(_ sender: Any) {
		formsCount += 1
		
		tableView.beginUpdates()
		tableView.insertRows(at: [IndexPath.init(row: formsCount - 1, section: 0)], with: .automatic)
		tableView.endUpdates()
		
		tableView.scrollToBottom()
	}
	
	@objc func questionTextDidChange(sender: UITextField) {
		guard let text = sender.text else { return }
		builder.setText(text, index: sender.tag)
	}
	
	@objc func correctAnswerDidChange(sender: UITextField) {
		guard let text = sender.text else { return }
		builder.setCorrectAnswer(text, index: sender.tag)
	}
	
	@objc func answerTwoDidChange(sender: UITextField) {
		guard let text = sender.text else { return }
		builder.setAnswerTwo(text, index: sender.tag)
	}
	
	@objc func answerThreeDidChange(sender: UITextField) {
		guard let text = sender.text else { return }
		builder.setAnswerThree(text, index: sender.tag)
	}
	
	@objc func answerFourDidChange(sender: UITextField) {
		guard let text = sender.text else { return }
		builder.setAnswerFour(text, index: sender.tag)
	}
	
	@IBAction func addQuestions(_ sender: Any) {
		let questions = builder.build()
		caretaker.addQuestions(questions)
		formsCount = 0
		goBack()
	}
	
	/// Выходит на главный экран после добавления вопросов
	private func goBack() {
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - UITableViewDataSource

extension AddQuestionViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		sectionsCount
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		formsCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuestionTableViewCell") as? AddQuestionTableViewCell
		else {
			return UITableViewCell ()
		}
		
		let tag = formsCount - 1
		configureCell(cell: cell, tag: tag)
		
		return cell
	}
}


// MARK: - Private methods

extension AddQuestionViewController {
	
	/// Задаёт полям ячейки TAG для опознания пре редактировании
	/// и выставляет экшны
	private func configureCell(cell: AddQuestionTableViewCell, tag: Int) {
		cell.questionText.addTarget(
			self,
			action: #selector(self.questionTextDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		cell.questionText.tag = tag
		
		cell.correctAnswer.addTarget(
			self,
			action: #selector(self.correctAnswerDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		cell.correctAnswer.tag = tag
		
		cell.answerTwo.addTarget(
			self,
			action: #selector(self.answerTwoDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		cell.answerTwo.tag = tag
		
		cell.answerThree.addTarget(
			self,
			action: #selector(self.answerThreeDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		cell.answerThree.tag = tag
		
		cell.answerFour.addTarget(
			self,
			action: #selector(self.answerFourDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		cell.answerFour.tag = tag
	}
}
