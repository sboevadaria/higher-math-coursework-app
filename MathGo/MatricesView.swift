import SwiftUI

struct MatricesView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showFinalParagraph = false
    @State private var showButton = false
    @State private var showExample = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What is a matrix?")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            if showFirstParagraph {
                Text("A matrix is a rectangular grid of numbers.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showSecondParagraph {
                Text("Matrices are useful because they can store information in an organized way.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showExample {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Example:")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    
                    MatrixText(
                        rows: [
                            ["1", "2"],
                            ["3", "4"]
                        ]
                    )
                    .formulaBoxStyle()
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            if showFinalParagraph {
                Text("Each number inside a matrix has its own position, based on its row and column.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showButton {
                NavigationButton(title: "Ready!", destination: MatrixPartsView())
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 26)
        .padding(.top, 8)
        .padding(.bottom, 24)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: объяснение, позицию элементов, пример или кнопку перехода
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showFinalParagraph {
                    showFinalParagraph = true
                } else if !showExample {
                    showExample = true
                } else {
                    showButton = true
                }
            }
        }
    }
}

// Reusable структура для отображения матриц
// Я использую ее во всех экранах, где нужно показать матрицу в более понятном виде
struct MatrixText: View {
    let rows: [[String]]
    let highlightedValue: String?
    let highlightColor: Color

    init(
        rows: [[String]],
        highlightedValue: String? = nil,
        highlightColor: Color = .primary
    ) {
        self.rows = rows
        self.highlightedValue = highlightedValue
        self.highlightColor = highlightColor
    }

    // Размер скобок зависит от количества строк в матрице
    var bracketSize: CGFloat {
        CGFloat(rows.count) * 44
    }

    var body: some View {
        HStack(spacing: 8) {
            Text("[")
                .font(.system(size: bracketSize, weight: .regular, design: .rounded))
                .frame(height: bracketSize)

            VStack(alignment: .center, spacing: 8) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: 18) {
                        ForEach(rows[rowIndex], id: \.self) { value in
                            Text(value)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .frame(minWidth: 26)
                                .foregroundColor(
                                    value == highlightedValue ? highlightColor : .primary
                                )
                        }
                    }
                }
            }

            Text("]")
                .font(.system(size: bracketSize, weight: .regular, design: .rounded))
                .frame(height: bracketSize)
        }
    }
}

#Preview {
    NavigationStack {
        MatricesView()
    }
}
