//
//  HomeViewModel.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/17/24.
//

import Foundation
import Combine

class HomeViewModel {
    @Published var bannerViewModels : [HomeBannerCollectionViewCellViewModel]?
    @Published var horizontalProductViewModels: [HomeProductCollectionViewCellViewModel]?
    @Published var verticalProductViewModels: [HomeProductCollectionViewCellViewModel]?
    
    private var loadDataTask : Task<Void,Never>?
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
        bannerViewModels = response.banners.map {
                HomeBannerCollectionViewCellViewModel(bannerImageUrl: $0.imageUrl)
        
        }
    }

    
    @MainActor
    private func transformHorizontalProduct(_ response: HomeResponse) async {
         horizontalProductViewModels = response.horizontalProducts.map{
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                   title: $0.title,
                                                   reasonDiscountString: $0.discount,
                                                   originalPrice: "\($0.originalPrice)",
                                                   discountPrice: "\($0.discountPrice)")
        }
    }
    
    @MainActor
    private func transformVerticalProduct(_ response:HomeResponse) async {
         verticalProductViewModels = response.verticalProducts.map{
            HomeProductCollectionViewCellViewModel(imageUrlString: $0.imageUrl,
                                                   title: $0.title,
                                                   reasonDiscountString: $0.discount,
                                                   originalPrice: "\($0.originalPrice)",
                                                   discountPrice: "\($0.discountPrice)")
        }
    }
}
