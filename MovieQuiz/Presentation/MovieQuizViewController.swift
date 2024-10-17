import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.font = UIFont(name: "YS Display Bold", size: 23)
        counterLabel.font = UIFont(name: "YS Display Medium", size: 20)
        yesButton.titleLabel?.font =  UIFont(name: "YS Display Medium", size: 20)
        noButton.titleLabel?.font =  UIFont(name: "YS Display Medium", size: 20)
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - QuestionFactoryDelegate
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true 
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func hideImageBorder() {
        imageView.layer.borderWidth = 0
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in self?.presenter.restartQuiz()
        }
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter?.showAlert(model: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") {[weak self] in
            
            guard let self else {return}
            
            self.presenter.restartQuiz()
        }
        alertPresenter?.showAlert(model: model)
    }
}

