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
	
	let careTaker = Caretaker(key: "questions")
	
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
		tableView.reloadData()
		tableView.scrollToBottom()
	}
	
	@objc func questionTextDidChange(sender: UITextField) {
		guard sender.text != nil else { return }
	}
	
	@objc func correctAnswerDidChange(sender: UITextField) {
		guard sender.text != nil else { return }
	}
	
	@objc func answerTwoDidChange(sender: UITextField) {
		guard sender.text != nil else { return }
	}
	
	@objc func answerThreeDidChange(sender: UITextField) {
		guard sender.text != nil else { return }
	}
	
	@objc func answerFourDidChange(sender: UITextField) {
		guard sender.text != nil else { return }
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
		
		cell.tag = indexPath.row
		
		cell.questionText.addTarget(
			self,
			action: #selector(self.questionTextDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		
		cell.correctAnswer.addTarget(
			self,
			action: #selector(self.questionTextDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		
		cell.answerTwo.addTarget(
			self,
			action: #selector(self.questionTextDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		
		cell.answerThree.addTarget(
			self,
			action: #selector(self.questionTextDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		
		cell.answerFour.addTarget(
			self,
			action: #selector(self.questionTextDidChange(sender:)),
			for: UIControl.Event.editingChanged
		)
		
		return cell
	}
}
