import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IB Outlets
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenter?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(viewController: self)
        
    }
    
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        checkAnswer(for: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        checkAnswer(for: false)
    }
    
    // MARK: - Public Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.show(quiz: viewModel)
        }
    }
    
    func didBeginLoading() {
        showLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating() // включаем анимацию
        
        view.bringSubviewToFront(activityIndicator) // поднимаем индикатор над картинкой
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // выключаем анимацию
    }
    
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion() // запрашиваем следующий вопрос
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func checkAnswer(for answer: Bool) { // Проверяем правильность ответа
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = answer
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // MARK: - Private Methods
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
    
    // приватный метод, который меняет цвет рамки, принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    // приватный метод для показа результатов раунда квиза, принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.present(alert: alertModel)
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев, метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let totalAccuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0)
            let text = """
                        Ваш результат \(correctAnswers)/\(questionsAmount),
                        Количество сыгранных квизов: \(String(statisticService?.gamesCount ?? 0))
                        Рекорд: \(String(statisticService?.bestGame.correct ?? 0))/\(String(statisticService?.bestGame.total ?? 0)) (\(statisticService?.bestGame.date.dateTimeString ?? ""))
                        Средняя точность: \(totalAccuracy)%
                        """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        let alertModel = AlertModel( // создаём алерт об ошибке загрузки
            title: "Ошибка",
            message: "Ошибка загрузки",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                self?.questionFactory?.loadData()
            }
        )
        alertPresenter?.present(alert: alertModel) // выводим алерт
    }
}
