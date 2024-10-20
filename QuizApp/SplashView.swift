//
//  SplashView.swift
//  QuizApp
//
//  Created by Gabriela Ruiz on 10/6/24.
//

import SwiftUI

struct SplashView: View {

    @State private var isActive = false

    @State private var size: CGFloat = 0.8

    @State private var opacity = 0.5

    @State private var imageOffsetY: CGFloat = 0



    var body: some View {

        if isActive {

            ContentView() // Navigate to ContentView when isActive is true

        } else {

            VStack {

                Spacer() // Spacer to push content to the top

    
                ZStack {

        Image("pink background")

                     .frame(width: 1000, height: 970)

                    VStack(spacing: 10) {

                        Image("letter")

                            .resizable()
                        

                            .edgesIgnoringSafeArea(.all)

                            .frame(width: 500, height: 500) // Adjust image size as needed

                            .offset(y: imageOffsetY) // Move image independently
                    }

                    .scaleEffect(size)

                    .opacity(opacity)

                    .onAppear {

                        withAnimation(.easeIn(duration: 1.2)) {

                            self.size = 0.9

                            self.opacity = 1.0

                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                            withAnimation {

                                self.imageOffsetY = 15 // Adjust image offset


                            }

                        }

                    }

                    

                    Spacer() // Spacer to push content to the bottom

                }

                .onAppear {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                        withAnimation {
                            
                            
                            self.isActive = true // Activate after 2 seconds

                        }

                    }

                }

            }

        }

    }

}


struct SplashView_Previews: PreviewProvider {

    static
    var previews: some View {

        SplashView()

    }

}

