import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(error model: AlertModel)
}
