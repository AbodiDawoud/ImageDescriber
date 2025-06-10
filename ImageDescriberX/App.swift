//
//  ImageDescriberXApp.swift
//  ImageDescriberX
    

import SwiftUI

@main
struct ImageDescriberXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: Self { self }
}
