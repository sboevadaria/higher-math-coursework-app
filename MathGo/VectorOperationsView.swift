import SwiftUI

struct VectorOperationsView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showLeftParts = false
    @State private var showRightParts = false
    @State private var showExamples = false
    @State private var showButton = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Vector operations")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph && !showExamples {
                    Text("Now let’s learn some basic vector operations.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                if showSecondParagraph {
                    Text("The main idea is simple: work with matching coordinates.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Сначала показываю только левую часть правил, а затем постепенно открываю результат
                if showLeftParts {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack(spacing: 6) {
                            Text("(a, b) + (c, d)")
                            
                            if showRightParts {
                                Text("= (a + c, b + d)")
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            Text("(a, b) - (c, d)")
                            
                            if showRightParts {
                                Text("= (a - c, b - d)")
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            Text("k · (a, b)")
                            
                            if showRightParts {
                                Text("= (ka, kb)")
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .formulaBoxStyle()
                        
                        HStack(spacing: 6) {
                            Text("-(a, b)")
                            
                            if showRightParts {
                                Text("= (-a, -b)")
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .formulaBoxStyle()
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
                
                // После правил показываю примеры, чтобы пользователь сразу увидел применение формул
                if showExamples {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Examples:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("1. (2, 3) + (1, 4) = (3, 7)")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .formulaBoxStyle()
                        
                        Text("2. (5, 4) - (2, 1) = (3, 3)")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .formulaBoxStyle()
                        
                        Text("3. 2 · (3, -1) - (1, 2) = (5, -4)")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                if showButton {
                    NavigationButton(
                        title: "Practice!",
                        destination: VectorPracticeView()
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 26)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: объяснение, правила, примеры или кнопку практики
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showLeftParts {
                    showLeftParts = true
                } else if !showRightParts {
                    showRightParts = true
                } else if !showExamples {
                    showExamples = true
                } else {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VectorOperationsView()
    }
}
