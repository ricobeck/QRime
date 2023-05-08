//
//  QRimeApp.swift
//  QRime Watch App
//
//  Created by Rico Becker on 08.05.23.
//

import SwiftUI
import Dynamic
@main
struct QRime_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let app = Dynamic.PUICApplication.sharedPUICApplication()
                    app._setStatusBarTimeHidden(true, animated: false, completion: nil)
                }
        }
    }
}
