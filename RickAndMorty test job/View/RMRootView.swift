//
//  RMRootView.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import SwiftUI

struct RMRootView: View {

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject private var viewModel = RMViewModel()

    @State private var characterIsPresented = false
    @State private var presentedCharacter: RMCharacterResponse?

    var body: some View {
        NavigationView {
            ZStack {
                contentBody
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                errorBody
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.startingCharactersRequest()
        }
    }

    private var contentBody: some View {
        VStack {
            titleBody
            divider
            dataBody
            divider
            controlsBody

            if let `presentedCharacter` = presentedCharacter {
                NavigationLink("", isActive: $characterIsPresented) {
                    RMDetailView(viewModel: viewModel,
                                 character: presentedCharacter,
                                 isPresented: $characterIsPresented)
                }
            }
        }
        .disabled(viewModel.isLoading)
    }

    @ViewBuilder
    private var titleBody: some View {
        Text("Rick & Morty")
            .font(.title)
        Text("Test job")
    }

    @ViewBuilder
    private var dataBody: some View {
        ScrollView() {
            ForEach(viewModel.currentPageCharacters, id: \.id) { character in
                Button {
                    presentedCharacter = character
                    characterIsPresented.toggle()
                } label: {
                    HStack {
                        photoBody(character)
                            .frame(width: 32, height: 32)
                            .cornerRadius(16)

                        Text(character.name)

                        Spacer()

                        Text(character.status.rawValue)
                    }
                    .padding([.leading, .trailing], 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    @ViewBuilder
    private func photoBody(_ character: RMCharacterResponse) -> some View {
        if viewModel.isPhotosLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else if let image = viewModel.currentPagePhotos[character.id] {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ZStack {
                Circle().foregroundColor(.gray)
                Text(character.nameInitials)
            }
        }
    }

    private var controlsBody: some View {
        HStack {
            Spacer()

            button(icon: "chevron.backward", disabled: !viewModel.hasPrevPage) {
                viewModel.prevPage()
            }

            Spacer()

            button(icon: "chevron.forward", disabled: !viewModel.hasNextPage) {
                viewModel.nextPage()
            }

            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private var errorBody: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke(Color.red, lineWidth: onePixel)

                Text(viewModel.errorMessage ?? "")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding(16)
            }
            .background(colorScheme == .light ? Color.white : Color.black)
            .padding(16)
            .frame(maxWidth: .infinity)

            Spacer()
                .layoutPriority(2)
        }
        .opacity(viewModel.errorMessage == nil ? 0 : 0.95)
        .animation(.linear(duration: 0.25), value: viewModel.errorMessage == nil)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RMRootView()
    }
}
