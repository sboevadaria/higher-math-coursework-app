import SwiftUI

struct VectorLengthView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showFormula = false
    @State private var showExample = false
    @State private var showButton = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coordinates and length")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            if showFirstParagraph {
                Text("A vector can be written using coordinates, like (x, y).")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showSecondParagraph {
                Text("For example, the vector (3, 2) means: move 3 steps right and 2 steps up.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            // После координат показываю формулу длины вектора
            if showFormula {
                VStack(alignment: .leading, spacing: 10) {
                    Text("The length of a vector is called its magnitude.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    
                    Text("Length of (x, y) = √(x² + y²)")
                        .formulaBoxStyle()
                }
                .transition(.opacity)
            }
            
            // Пример показывает, как формула применяется к конкретному вектору
            if showExample {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Example:")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    Text("Find the length of the vector v = (3, 4).")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .formulaBoxStyle()
                    
                    Text("""
                    = √(3² + 4²) = 
                    = √(9 + 16) = 
                    = √25 = 
                    = 5
                    """)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .formulaBoxStyle()
                }
                .transition(.opacity)
            }
            
            if showButton {
                NavigationButton(
                    title: "Cool!",
                    destination: VectorOperationsView()
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 26)
        .padding(.bottom, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: координаты, формулу, пример или кнопку перехода
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showFormula {
                    showFormula = true
                } else if !showExample {
                    showExample = true
                } else {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VectorLengthView()
    }
}
