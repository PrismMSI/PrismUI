//
//  KeyView.swift
//  PrismSwiftUI
//
//  Created by Erik Bautista on 9/19/21.
//

import SwiftUI
import PrismKit

struct KeyView: View {
    @ObservedObject var viewModel: KeyViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .fill(keyColor)
                .opacity(0.4)
                .overlay(
                    Rectangle()
                        .strokeBorder(keyColor,
                                      lineWidth: viewModel.selected ? 3 : 0)
                )

            Circle()
                .fill(keyColor)
                .frame(width: 10, height: 10, alignment: .topLeading)
                .position(x: 10, y: 10)

            Text("\(viewModel.ssKey.name)")
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .cornerRadius(4)
        .onTapGesture {
            withAnimation(Animation.easeIn(duration: 0.15)) {
                viewModel.selected.toggle()
            }
        }
        .onAppear {
            viewModel.apply(.onAppear)
        }
    }

    var keyColor: Color {
        var color = RGB()

        if viewModel.ssKey.mode == .steady ||
            viewModel.ssKey.mode == .reactive ||
            viewModel.ssKey.mode == .disabled {
            color = viewModel.ssKey.main
        } else if viewModel.ssKey.mode == .colorShift ||
                    viewModel.ssKey.mode == .breathing {
            color = viewModel.getColor()
        }
        return Color(red: color.red, green: color.green, blue: color.blue)
    }
}

struct PerKeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView(viewModel: KeyViewModel(ssKey: .empty, model: .perKeyGS65))
    }
}
