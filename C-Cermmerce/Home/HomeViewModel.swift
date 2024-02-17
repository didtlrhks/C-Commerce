//
//  HomeViewModel.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/17/24.
//

import Foundation
import Combine

class HomeViewModel {
    enum Action {
        case loadData
    }
    final class State{
        struct CollectionViewModels{
             var bannerViewModels : [HomeBannerCollectionViewCellViewModel]?
             var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
             var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
        }
        @Published var collectionViewModels : CollectionViewModels = CollectionViewModels()
        }
    private(set) var state : State = State()
    private var loadDataTask : Task<Void,Never>?
    
    func process(action: Action) {
        switch action {
        case .loadData:
            loadData()
        }
    }
    func loadData() {
        loadDataTask = Task{
            do {
                let response = try await NetworkService.shared.getHoemData()
                Task{
                    await transformBanner(response)
                }
                Task{
                    await transformHorizontalProduct(response)
                }
                Task{
                    await transformVerticalProduct(response)
                }
            }
            catch {
                print("nework error : \(error)")
            }
        }
    }
    deinit{
        loadDataTask?.cancel()
    }
    
    @MainActor
    private func transformBanner(_ response: HomeResponse) async
    {
        state.collectionViewModels.bannerViewModels = response.banners.map {
                HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        
        }
    }

    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
        state.collectionViewModels.horizontalProductViewModels = response.horizontalProducts.map{
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                   title: $0.title,
                                                   reasonDiscountString: $0.discount,
                                                   originalPrice: "\($0.originalPrice)",
                                                   discountPrice: "\($0.discountPrice)")
        }
    }
    
    @MainActor
    private func transformVerticalProduct(_ response:HomeResponse) async {
        state.collectionViewModels.verticalProductViewModels = response.verticalProducts.map{
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                   title: $0.title,
                                                   reasonDiscountString: $0.discount,
                                                   originalPrice: "\($0.originalPrice)",
                                                   discountPrice: "\($0.discountPrice)")
        }
    }
}