import SwiftUI

struct IntegralsView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showThirdParagraph = false
    @State private var showFourthParagraph = false
    @State private var showGraph = false
    @State private var goToNextScreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What is an integral?")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            if showFirstParagraph {
                Text("An integral finds the accumulated value of a function over an interval.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showSecondParagraph {
                Text("In simple words, an integral adds up small pieces to find the total.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showThirdParagraph {
                Text("Geometrically, it represents the area under a graph.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }

            // После текстового объяснения показываю график, чтобы визуально связать интеграл с площадью под кривой
            if showGraph {
                IntegralGraphView()
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 26)
        .padding(.bottom, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: объяснение, визуализацию или переход дальше
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showThirdParagraph {
                    showThirdParagraph = true
                } else if !showFourthParagraph {
                    showFourthParagraph = true
                } else if !showGraph {
                    showGraph = true
                } else {
                    goToNextScreen = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextScreen) {
            IntegralsUsageView()
        }
    }
}

#Preview {
    NavigationStack {
        IntegralsView()
    }
}
