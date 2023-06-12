//
//  Home.swift
//  Telegram Dynamic Island
//
//  Created by Erif Fanani on 05/06/23.
//

import SwiftUI

struct Home: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    @State private var scrollProgress: CGFloat = 0
    //@Environment(\.colorScheme) private var colorScheme
    @State private var textHeaderOffset: CGFloat = 0
    var body: some View {
        let isHavingNotch = safeArea.bottom != 0
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 12) {
                Image("imgProfile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // Adding blur and reducing size based on scroll progress
                    .frame(width: 130 - (75 * scrollProgress), height: 130 - (75 * scrollProgress))
                    // Hiding main view so that the dynamic island metaball effect will be vivible
                    .opacity(1 - scrollProgress)
                    .blur(radius: scrollProgress * 10, opaque: true)
                    .clipShape(Circle())
                    .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                        return ["HEADER": $0]
                    })
                    .padding(.top, safeArea.top + 15)
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") { scrollRect in
                        guard isHavingNotch else { return }
                        let progress = -scrollRect.minY / 25
                        scrollProgress = min(max(progress, 0), 1)
                    }
                
                let fixedTop: CGFloat = safeArea.top + 1
                let collapsed = textHeaderOffset < fixedTop
                Text("John Doe - IT Support")
                    .font(.callout)
                    .foregroundColor(collapsed ? Color.title : Color.subtitle)
                    .padding(.vertical, 15)
                    .background(content: {
                        Rectangle()
                            //.fill(colorScheme == .dark ? .black : .gray.opacity(0.1))
                            .fill(collapsed ? Color.card : Color.page)
                            .frame(width: size.width)
                            .padding(.top, collapsed ? -safeArea.top : 0)
                            .shadow(color: .black.opacity(collapsed ? 0.1 : 0), radius: 5, x: 0, y: 5)
                    })
                    // Stopping at the top
                    .offset(y: collapsed ? -(textHeaderOffset - fixedTop) : 0)
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") {
                        textHeaderOffset = $0.minY
                    }
                    .zIndex(10)
                
                SampleRow()
                    .padding(.horizontal, 12)
                
            }
            .padding(.top, safeArea.top + 15)
            .frame(maxWidth: .infinity)
            
        }
        .backgroundPreferenceValue(AnchorKey.self, { pref in
            GeometryReader { proxy in
                if let anchor = pref["HEADER"], isHavingNotch {
                    let frameRect = proxy[anchor]
                    let isHavingDynamicIsland = safeArea.top > 51
                    let capsuleHeight = isHavingDynamicIsland ? 37 : (safeArea.top - 15)
                    
                    Canvas { out, size in
                        out.addFilter(.alphaThreshold(min: 0.5))
                        out.addFilter(.blur(radius: 12))
                        
                        out.drawLayer { ctx in
                            if let headerView = out.resolveSymbol(id: 0) {
                                ctx.draw(headerView, in: frameRect)
                            }
                            
                            if let dynamicIsland = out.resolveSymbol(id: 1) {
                                // Placing Dynamic island
                                let rect = CGRect(x: (size.width - 120) / 2, y: isHavingDynamicIsland ? 11 : 0, width: 120, height: capsuleHeight)
                                ctx.draw(dynamicIsland, in: rect)
                            }
                        }
                    } symbols: {
                        HeaderView(frameRect)
                            .tag(0)
                            .id(0)
                        
                        DynamicIslandCapsule(capsuleHeight)
                            .tag(1)
                            .id(1)
                        
                    }
                }
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.page)
                    .frame(height: 15)
            }
            
        })
        .overlay(alignment: .top, content: {
            HStack {
                Button {
                    
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                Spacer()
                Button {
                    
                } label: {
                    Text("Edit")
                }
            }
            .padding(15)
            .padding(.top, safeArea.top)
            
        })
        .coordinateSpace(name: "SCROLLVIEW")
        
    }
    
    // Canvas symbols
    @ViewBuilder
    func HeaderView(_ frameRect: CGRect) -> some View {
        Circle()
            .fill(.black)
            .frame(width: frameRect.width, height: frameRect.height)
    }
    
    @ViewBuilder
    func DynamicIslandCapsule(_ height: CGFloat = 37) -> some View {
        Capsule()
            .fill(.black)
            .frame(width: 120, height: height)
    }
    
    @ViewBuilder
    func SampleRow() -> some View {
        VStack {
            ForEach(1...20, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 0) {
                    
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.card)
                        .frame(height: 100)
                        .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 0.8)
                        .padding(.top, 10)
                    
                }
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeDark_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
