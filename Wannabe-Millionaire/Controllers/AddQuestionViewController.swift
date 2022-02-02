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
	
	/// Массив вопросов
	var questions: [Question] = []
	
	/// Кол-во форм для вопросов
	var formsCount: Int = 1
	
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
}

// MARK: - UITableViewDataSource

extension AddQuestionViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		formsCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddQuestionTableViewCell") as? AddQuestionTableViewCell
		else {
			return UITableViewCell ()
		}
		
		return cell
	}
}
