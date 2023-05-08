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

    private var cancellable: AnyCancellable?

    init() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

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
                                .foregroundColor(matrix[row, column] ? .accentColor : .black)
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
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
