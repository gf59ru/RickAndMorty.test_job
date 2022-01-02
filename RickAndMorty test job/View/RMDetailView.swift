//
//  RMDetailView.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import SwiftUI



struct RMDetailView: View {

    @ObservedObject private var viewModel: RMViewModel
    let character: RMCharacterResponse
    let isPresented: Binding<Bool>

    init(viewModel: RMViewModel,
         character: RMCharacterResponse,
         isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.character = character
        self.isPresented = isPresented
    }

    var body: some View {
        ScrollView {
            photoBody
                .frame(width: 300, height: 300)
                .cornerRadius(150)

            propertiesBody

            keyValueBody(title: "Origin", value: character.origin)
            keyValueBody(title: "Location", value: character.location)
            keyValueBody(title: "Episode(s)", items: character.episode)
        }
        .navigationTitle(Text(character.name))
    }

    @ViewBuilder
    private var photoBody: some View {
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
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }

    @ViewBuilder
    private var propertiesBody: some View {
        character.gender
        character.status
        character.species
        keyValueBody(title: "Type", value: character.type.count == 0 ? "—" : character.type)
    }

}

struct RMDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
