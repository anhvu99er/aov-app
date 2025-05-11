import SwiftUI

struct SplashView: View {
    @State private var offsetX: CGFloat = -300
    @State private var opacity: Double = 1.0
    @State private var isActive = false

    var body: some View {
        if isActive {
            MainTabView()
                .transition(.opacity)
        } else {
            ZStack {
                Color.black.ignoresSafeArea()

                Image("aovcheat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220)
                    .offset(x: offsetX)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.2)) {
                            offsetX = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                offsetX = 300
                                opacity = 0.0
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            isActive = true
                        }
                    }
            }
        }
    }
}
