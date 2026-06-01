import SwiftUI

struct GeneralFormulasView: View {
    @State private var showFirstParagraph = false
    @State private var showLeftParts = false
    @State private var showRightParts = false
    @State private var showSecondParagraph = false
    
    // Отвечает за переход к practice screen, если переход будет запускаться через state
    @State private var goToPracticeScreen = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("But first...")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("...let's learn some general function formulas!")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Сначала показываю только левые части формул
                if showLeftParts {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(xⁿ)")
                            
                            if showRightParts {
                                Text("= n xⁿ⁻¹")
                                    .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(eˣ)")
                            
                            if showRightParts {
                                Text("= eˣ")
                                    .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(aˣ)")
                            
                            if showRightParts {
                                Text("= aˣ ln(a)")
                                    .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(ln(x))")
                            
                            if showRightParts {
                                HStack(spacing: 6) {
                                    Text("=")
                                    FractionText(top: "1", bottom: "x", lineWidth: 24)
                                }
                                .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(logₐ(x))")
                            
                            if showRightParts {
                                HStack(spacing: 6) {
                                    Text("=")
                                    FractionText(top: "1", bottom: "x ln(a)", lineWidth: 80)
                                }
                                .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                    }
                }
                
                if showSecondParagraph {
                    Text("Now you are finally ready to solve a couple of problems!")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                
                    NavigationButton(title: "Start!", destination: DerFirstPracticeView())
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 26)
            .padding(.bottom, 12)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Формулы появляются в два этапа: сначала выражения, потом их производные
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showLeftParts {
                    showLeftParts = true
                } else if !showRightParts {
                    showRightParts = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                }
            }
        }
        .navigationDestination(isPresented: $goToPracticeScreen) {
            DerFirstPracticeView()
        }
    }
}

// Reusable структура для отображения дробей без использования "/"
// Я использую ее в формулах, чтобы математическая запись выглядела понятнее
struct FractionText: View {
    let top: String
    let bottom: String
    let lineWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 2) {
            Text(top)
            
            Rectangle()
                .frame(width: lineWidth, height: 1)
            
            Text(bottom)
        }
        .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}

// Reusable modifier для больших формульных блоков
// Он помогает сделать одинаковый стиль у формул на разных экранах
extension View {
    func formulaBoxStyle() -> some View {
        self
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        GeneralFormulasView()
    }
}
