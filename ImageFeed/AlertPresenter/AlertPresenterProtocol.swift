import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showError(error model: AlertModel)
}
