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
    let contentView = ContentView()
    @State var statusBarHidden: Bool = true
    
    var body: some Scene {
        WindowGroup {
            contentView
                .onAppear {
                    let app = Dynamic.PUICApplication.sharedPUICApplication()
                    app._setStatusBarTimeHidden(statusBarHidden, animated: false, completion: nil)
                }
                .onLongPressGesture() {
                    statusBarHidden = !statusBarHidden
                    let app = Dynamic.PUICApplication.sharedPUICApplication()
                    app._setStatusBarTimeHidden(statusBarHidden, animated: false, completion: nil)
                }
        }
    }
}
