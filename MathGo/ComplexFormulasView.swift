import SwiftUI

// Этот экран знакомит пользователяс с производными тригонометрических и обратных тригонометрических функций
struct ComplexFormulasView: View {
    
    // State management
    @State private var showFirstParagraph = false
    @State private var showLeftParts = false
    @State private var showRightParts = false
    @State private var goToNextScreen = false
    @State private var showSecondParagraph = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Time for the next level!")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("We’ll now explore trigonometric functions.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Сначала показываю только левые части формул, чтобы пользователь видел сами функции
                if showLeftParts {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(sin(x))")
                            
                            // Правые части формул появляются отдельно, чтобы не перегружать экран сразу
                            if showRightParts {
                                Text("= cos(x)")
                                    .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(cos(x))")
                            
                            if showRightParts {
                                Text("= -sin(x)")
                                    .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(tan(x))")
                            
                            if showRightParts {
                                Text("= sec²(x)")
                                    .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(arcsin(x))")
                            
                            if showRightParts {
                                HStack(spacing: 6) {
                                    Text("=")
                                    FractionText(top: "1", bottom: "√(1 - x²)", lineWidth: 80)
                                }
                                .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(arccos(x))")
                            
                            if showRightParts {
                                HStack(spacing: 6) {
                                    Text("=")
                                    FractionText(top: "-1", bottom: "√(1 - x²)", lineWidth: 80)
                                }
                                .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            FractionText(top: "d", bottom: "dx", lineWidth: 24)
                            Text("(arctan(x))")
                            
                            if showRightParts {
                                HStack(spacing: 6) {
                                    Text("=")
                                    FractionText(top: "1", bottom: "1 + x²", lineWidth: 64)
                                }
                                .transition(.opacity)
                            }
                        }
                        .formulaBoxStyle()
                    }
                }
                
                // После появления всех формул пользователь может перейти к практике
                if showSecondParagraph {
                    NavigationButton(title: "Let's play!", destination: DerSecondPracticeView())
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
        .navigationDestination(isPresented: $goToNextScreen) {
            DerSecondPracticeView()
        }
    }
}

#Preview {
    NavigationStack {
        ComplexFormulasView()
    }
}

