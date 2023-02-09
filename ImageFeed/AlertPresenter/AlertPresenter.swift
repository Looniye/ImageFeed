import UIKit

final class AlertPresenter: AlertPresenterProtocol{
    private weak var delegate: UIViewController?
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showError(error model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: { _ in
                model.completion()
            }
        ))
        delegate?.present(alert, animated: true)
    }
}
