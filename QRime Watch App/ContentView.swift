//
//  ContentView.swift
//  QRime Watch App
//
//  Created by Rico Becker on 08.05.23.
//

import SwiftUI
import Combine
import QRCode

final class ContentViewModel: ObservableObject {
    @Published var time: String = ""
    @Published var gridData: BoolMatrix?
    @Published var displayMode: ContentViewDisplayModes

    private var cancellable: AnyCancellable?

    init() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        displayMode = .normal
        
        cancellable = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .sink {[weak self] _ in
                let date = Date()
                let time = dateFormatter.string(from: date)
                self?.time = time

                let doc = QRCode.Document(utf8String: time, errorCorrection: .medium)
                withAnimation {
                    self?.gridData = doc.boolMatrix
                }
            }
    }
    
    func foregroundColorForDisplayMode() -> Color {
        switch displayMode {
        case .normal:
            return .accentColor
        case .inverted:
            return Color.black
        case .blackOnWhite:
            return Color.black
        case .whiteOnBlack:
            return Color.white
        }
    }

    func backgroundColorForDisplayMode() -> Color {
        switch displayMode {
        case .normal:
            return Color.black
        case .inverted:
            return .accentColor
        case .blackOnWhite:
            return Color.white
        case .whiteOnBlack:
            return Color.black
        }
    }
    
    func switchDisplayMode() {
        switch displayMode {
        case .normal:
            self.displayMode = .inverted
        case .inverted:
            self.displayMode = .blackOnWhite
        case .blackOnWhite:
            self.displayMode = .whiteOnBlack
        case .whiteOnBlack:
            self.displayMode = .normal
        }
    }
}

enum ContentViewDisplayModes {
    case normal
    case inverted
    case blackOnWhite
    case whiteOnBlack
}

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        if let matrix = viewModel.gridData {
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0 ..< matrix.dimension, id: \.self) { row in
                    GridRow {
                        ForEach(0 ..< matrix.dimension, id: \.self) { column in
                            Rectangle()
                                .foregroundColor(matrix[row, column] ? viewModel.foregroundColorForDisplayMode() : viewModel.backgroundColorForDisplayMode())
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }.gesture(
                TapGesture()
                    .onEnded {
                        viewModel.switchDisplayMode()
                    }
            )
        } else {
            Text(viewModel.time)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
