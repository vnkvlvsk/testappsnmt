//
//  NewsView.swift
//  TestApp
//
//  Created by Kavaleuski Ivan on 23/05/2025.
//

import SwiftUI

struct NewsView: View {
    @StateObject var newsViewModel: NewsViewModel
    let alertManager: AlertManager = AlertManager.shared
    
    var body: some View {
        ZStack {
                List {
                    Picker("Select", selection: $newsViewModel.selectedListSegment) {
                        ForEach(NewsViewModel.ListPickerSegment.allCases) { segment in
                            Text(segment.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.baseBlack)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                    switch newsViewModel.selectedListSegment {
                    case .all:
                        allItemsStateView
                    case .blocked:
                        blockedItemsStateView
                    case .favorites:
                        favoritesItemsStateView
                    }
                }
        }
        .listStyle(.plain)
        .listRowSpacing(-8)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .refreshable {
            newsViewModel.refresh()
        }
        .navigationTitle("News")
        .background(.baseBeige)
        .onAppear {
            newsViewModel.loadData()
        }
        .navigationDestination(isPresented: $newsViewModel.isPushNavigation.0, destination: {
            if let item = newsViewModel.isPushNavigation.1 {
                NavigationPushView(navigationItem: item)
            }
        })
        .sheet(isPresented: $newsViewModel.isShowModalNavigation.0) {
            if let item = newsViewModel.isShowModalNavigation.1 {
                NavigationModalView(
                    isShowView: $newsViewModel.isShowModalNavigation.0,
                    navigationItem: item
                )
            }
        }
        .fullScreenCover(isPresented: $newsViewModel.isShowFullScreenNavigation.0) {
            if let item = newsViewModel.isShowFullScreenNavigation.1 {
                NavigationFullScreenView(
                    isShowView: $newsViewModel.isShowFullScreenNavigation.0,
                    navigationItem: item
                )
            }
        }
    }
}

extension NewsView {
    var allItemsStateView: some View {
        Group {
            if newsViewModel.feedItems.isEmpty {
                VStack(spacing: 8) {
                    Spacer(minLength: 100)
                    
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.baseBlue)
                        .font(.system(size: 40, weight: .thin))
                    
                    Text("No Results")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.baseBlack)
                    
                    Button {
                        newsViewModel.refresh()
                    } label: {
                        ZStack {
                            Text("Refresh")
                                .foregroundColor(.white)
                                .font(.system(size: 17, weight: .bold))
                                .frame(maxWidth: .infinity)
                            
                            HStack {
                                Spacer()
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 20, weight: .thin))
                            }
                            .padding(.trailing, 16)
                        }
                        .frame(height: 44)
                        .background(.baseBlue)
                        .foregroundColor(.white)
                        .clipShape(.rect(cornerRadius: 4))
                        .padding(.horizontal, 32)
                    }
                    .padding(.top, 4)
                    Spacer()
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(newsViewModel.feedItems) { item in
                    switch item {
                    case .news(let news):
                        NewsCellView(
                            news: news,
                            isInFavorite: newsViewModel.favoriteNews.contains(news),
                            segmentState: newsViewModel.selectedListSegment,
                            didTapCell: {
                                guard let url = URL(string: news.webUrl) else { return }
                                UIApplication.shared.open(url)
                            },
                            didTapAddToFavourites: {
                                if newsViewModel.favoriteNews.contains(news) {
                                    newsViewModel.removeNewsFromFavourites(news)
                                } else {
                                    newsViewModel.addNewsToFavourites(news)
                                }
                            },
                            didTapBlock: {
                                alertManager.show(
                                    .init(
                                        title: "Do you want to block?",
                                        message: "Confirm to hide this news source",
                                        primaryAction: .destructive(Text("Block"), action: {
                                            newsViewModel.blockNews(news)
                                        }),
                                        secondaryAction: .cancel()
                                    )
                                )
                            }
                        )
                        .onAppear {
                            newsViewModel.loadNextPageIfNeeded(currentItem: news)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    case .navigation(let navigation, _):
                        NavigationBlockView(block: navigation) {
                            newsViewModel.navigationButtonHandle(navigation)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
            }
        }
    }
    
    var favoritesItemsStateView: some View {
        Group {
            if newsViewModel.favoriteNews.isEmpty {
                VStack(spacing: 8) {
                    Spacer(minLength: 100)
                    
                    Image(systemName: "heart.circle.fill")
                        .foregroundColor(.baseBlue)
                        .font(.system(size: 40, weight: .thin))
                    
                    Text("No Favorite News")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.baseBlack)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(newsViewModel.favoriteNews) { news in
                    NewsCellView(
                        news: news,
                        isInFavorite: false,
                        segmentState: newsViewModel.selectedListSegment,
                        didTapCell: {
                            guard let url = URL(string: news.webUrl) else { return }
                            UIApplication.shared.open(url)
                        },
                        didTapAddToFavourites: {
                            if newsViewModel.favoriteNews.contains(news) {
                                newsViewModel.removeNewsFromFavourites(news)
                            } else {
                                newsViewModel.addNewsToFavourites(news)
                            }
                        },
                        didTapBlock: {
                            alertManager.show(
                                .init(
                                    title: "Do you want to unblock?",
                                    message: "Confirm to hide this news source",
                                    primaryAction: .destructive(Text("Block"), action: {
                                        newsViewModel.blockNews(news)
                                    }),
                                    secondaryAction: .cancel()
                                )
                            )
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var blockedItemsStateView: some View {
        Group {
            if newsViewModel.blockedNews.isEmpty {
                VStack(spacing: 8) {
                    Spacer(minLength: 100)
                    
                    Image(systemName: "nosign")
                    .foregroundColor(.baseBlue)
                    .font(.system(size: 40, weight: .thin))
                    
                    Text("No Blocked News")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.baseBlack)
                
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(newsViewModel.blockedNews) { news in
                    NewsCellView(
                        news: news,
                        isInFavorite: false,
                        segmentState: newsViewModel.selectedListSegment,
                        didTapCell: {
                            guard let url = URL(string: news.webUrl) else { return }
                            UIApplication.shared.open(url)
                        },
                        didTapBlock: {
                            alertManager.show(
                                .init(
                                    title: "Do you want to unblock?",
                                    message: "Confirm to hide this news source",
                                    primaryAction: .destructive(Text("Unblock"), action: {
                                        newsViewModel.unblockNews(news)
                                    }),
                                    secondaryAction: .cancel()
                                )
                            )
                        }
                    )
                    .onAppear {
                        newsViewModel.loadNextPageIfNeeded(currentItem: news)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
    }
}
