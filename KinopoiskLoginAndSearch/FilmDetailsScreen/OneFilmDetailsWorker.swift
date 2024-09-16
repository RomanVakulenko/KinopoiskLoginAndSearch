//
//  OneFilmDetailsWorker.swift
//  KinopoiskLoginAndSearch
//
//  Created by Roman Vakulenko on 14.09.2024.
//

import Foundation

protocol OneFilmDetailsWorkingLogic {
    func getFilmDetails(id: Int, completion: @escaping (Result<DetailsFilm, NetworkManagerErrors>) -> Void)
    func loadFilmImages(id: Int,
                        completion: @escaping (Result<[OneStill], NetworkManagerErrors>) -> Void)
}

final class OneFilmDetailsWorker: OneFilmDetailsWorkingLogic {
    
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
    private var currentPageForStills = 1
    private var isFetching = false

    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    // MARK: - Public methods
    func getFilmDetails(id: Int,
                        completion: @escaping (Result<DetailsFilm, NetworkManagerErrors>) -> Void) {

        networkManager.getFilmDetails(id: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let films):
                completion(.success(films))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadFilmImages(id: Int,
                        completion: @escaping (Result<[OneStill], NetworkManagerErrors>) -> Void) {
        guard !isFetching else { return }
        isFetching = true

        networkManager.loadFilmImages(id: id, 
                                      pageForStills: currentPageForStills) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let films):
                self.currentPageForStills += 1
                completion(.success(films))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
