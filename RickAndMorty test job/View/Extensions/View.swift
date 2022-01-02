//
//  View.swift
//  RickAndMorty test job
//
//  Created by Nikolai Borovennikov on 31.12.2021.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func button(icon: String,
                disabled: Bool,
                action: @escaping () -> Void) -> some View {
        ZStack {
            Button {
                action()
            } label: {
                Image(systemName: icon)
                    .font(.title)
            }
            .disabled(disabled)

            Circle()
                .stroke(Color.gray, lineWidth: onePixel)
                .background(Color.clear)
        }
        .frame(width: 64, height: 64)
        .opacity(disabled ? 0.5 : 1)
    }

    var divider: some View {
        Color.gray
            .frame(maxWidth: .infinity)
            .frame(height: onePixel)
    }

    @ViewBuilder
    func keyValueBody<T>(title: String, value: T) -> some View
    where T: RMValueView {
        divider.padding([.leading, .trailing], 16)
        switch value.layout {
        case .vertical:
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.caption)
                    Spacer()
                }
                value.content
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 16)
        case .horizontal:
            HStack {
                Text(title)
                    .font(.caption)
                Spacer()
                value.content
            }
            .padding([.leading, .trailing], 16)
        }
    }

    @ViewBuilder
    func keyValueBody<T>(title: String, items: [T]) -> some View
    where T: RMValueView, T: Hashable {
        divider.padding([.leading, .trailing], 16)
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.caption)
                Spacer()
            }
            ForEach(items, id: \.self) { item in
                item.content
            }
        }
        .padding([.leading, .trailing], 16)
    }

    var onePixel: CGFloat {
        1 / UIScreen.main.scale
    }

}
