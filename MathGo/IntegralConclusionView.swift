import SwiftUI

struct IntegralConclusionView: View {
    @State private var showFirstParagraph = false
    @State private var showUses = false
    @State private var showDoubleTriple = false
    @State private var showFinalText = false
    @State private var showButton = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Where can integrals be used?")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("Integrals are used whenever we need to add up many tiny pieces to find a total.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Здесь показываю реальные области применения интегралов
                if showUses {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Integrals can help us find:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("1. distance traveled from speed")
                        Text("2. total profit or cost over time")
                        Text("3. volume, mass, and accumulated change")
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .prettyInfoBox()
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Коротко показываю, что идея интегралов может расширяться дальше
                if showDoubleTriple {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Double integrals add up values over a flat region. Triple integrals add up values inside a 3D object.")
                        
                        Text("∫∫   and   ∫∫∫")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .prettyInfoBox()
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showFinalText {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("We won’t cover double and triple integrals here, but now you are familiar with the fascinating concept of integrals.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                    }
                    .prettyInfoBox()
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showButton {
                    NavigationButton(
                        title: "Made it!",
                        destination: ContentView()
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: применение, расширение темы, финальный текст или кнопку
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showUses {
                    showUses = true
                } else if !showDoubleTriple {
                    showDoubleTriple = true
                } else if !showFinalText {
                    showFinalText = true
                } else if !showButton {
                    showButton = true
                }
            }
        }
    }
}

// Reusable modifier для информационных блоков в заключительной части темы
extension View {
    func prettyInfoBox() -> some View {
        self
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.black.opacity(0.18), lineWidth: 1.5)
            )
            .shadow(radius: 3, y: 2)
    }
}

#Preview {
    NavigationStack {
        IntegralConclusionView()
    }
}
