//
//  ContentView.swift
//  Telegram Dynamic Island
//
//  Created by Erif Fanani on 05/06/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea()
            
        }
        .background(Color.page)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
