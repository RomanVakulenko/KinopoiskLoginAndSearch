//
//  LogInRegistrController.swift
//  KinopoiskLoginAndSearch
//
//  Created by Roman Vakulenko on 14.09.2024.
//


import UIKit
import SnapKit

protocol LogInRegistrDisplayLogic: AnyObject {
    func displayUpdate(viewModel: LogInRegistrFlow.Update.ViewModel)
//    func displayWaitIndicator(viewModel: LogInRegistrFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: LogInRegistrFlow.AlertInfo.ViewModel)
    func displayRouteToFilmsScreen(viewModel: LogInRegistrFlow.RoutePayload.ViewModel)
}

final class LogInRegistrController: UIViewController, AlertDisplayable {

    var interactor: LogInRegistrBusinessLogic?
    var router: (LogInRegistrRoutingLogic & LogInRegistrDataPassing)?

    lazy var contentView: LogInRegistrViewLogic = LogInRegistrView()

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.onDidLoadViews(request: LogInRegistrFlow.OnDidLoadViews.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.doLoginAndPasswordEmpty(request: LogInRegistrFlow.OnDidLoadViews.Request())
    }

    // MARK: - Private methods

    private func configure() {
        contentView.output = self
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {}

    private func configureConstraints() {}
}


// MARK: - LogInRegistrDisplayLogic
extension LogInRegistrController: LogInRegistrDisplayLogic {
    
    func displayRouteToFilmsScreen(viewModel: LogInRegistrFlow.RoutePayload.ViewModel) {
        router?.routeToFilmsScreen()
    }

    func displayUpdate(viewModel: LogInRegistrFlow.Update.ViewModel) {
        contentView.update(viewModel: viewModel)
    }

//    func displayWaitIndicator(viewModel: LogInRegistrFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }

    func displayAlert(viewModel: LogInRegistrFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.firstButtonTitle ?? "Ok")
    }
}


 // MARK: - LogInRegistrViewOutput
extension LogInRegistrController: LogInRegistrViewOutput {

    func useCurrent(loginText: String, passwordText: String) {
        interactor?.useCurrent(loginText: loginText,
                               passwordText: passwordText)
    }

    func enterButtonTapped() {
        interactor?.enterButtonTapped(request: LogInRegistrFlow.OnEnterButtonTap.Request())
    }

}


// MARK: - FilmsDelegate
extension LogInRegistrController: FilmsDelegate {
    func doLogOut() {
        interactor?.logOut()
    }
}


