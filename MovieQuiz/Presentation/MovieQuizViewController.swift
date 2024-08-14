import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - IB Outlets
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Public Methods
    func didBeginLoading() {
        showLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating() // включаем анимацию
        view.bringSubviewToFront(activityIndicator) // поднимаем индикатор над картинкой
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    // MARK: - Private Methods
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: { [weak self] in
                self?.presenter.restartGame()
            }
        )
        alertPresenter?.present(alert: alertModel)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        let alertModel = AlertModel( // создаём алерт об ошибке загрузки
            title: "Ошибка",
            message: "Ошибка загрузки",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
            }
        )
        alertPresenter?.present(alert: alertModel) // выводим алерт
    }
}
