import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
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
        statisticService = StatisticService()
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        showLoadingIndicator()
        questionFactory.loadData()
        //showQuestion(questionIndex: currentQuestionIndex)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // приватный метод, который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        // метод красит рамку
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        correctAnswers += isCorrect ? 1 : 0
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n\(getStatisticsText())",
                                            buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            showQuestion(questionIndex: currentQuestionIndex)
        }
    }
    
    private func showQuestion(questionIndex: Int) {
        guard 0 ..< questionsAmount ~= questionIndex else { return }
        
        questionFactory?.requestNextQuestion()
        
    }
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод для показа результатов раунда квиза
    private func show(quiz result: QuizResultsViewModel) {
        
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in self?.restartQuiz()
        }
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter?.showAlert(model: model)
    }
    
    private func restartQuiz(){
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    private func getStatisticsText() -> String {
        guard let statisticsService = statisticService else {
            return "Статистика отсутствует"
        }
        
        let gamesCount = statisticsService.gamesCount
        let bestGame = "\(statisticsService.bestGame.correct)/\(statisticsService.bestGame.total)"
        let bestGameDate = statisticsService.bestGame.date.dateTimeString
        let overallAccuracy = String(format: "%.2f", statisticsService.totalAccuracy * 100)
        
        return "Количество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame) (\(bestGameDate))\nСредняя точность: \(overallAccuracy)%"
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") {[weak self] in
            guard let self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(model: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
}

