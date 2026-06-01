import SwiftUI

struct MatrixRevisionView: View {
    // Пары для revision game по основным понятиям из темы matrices
    let pairs = [
        RevisionPair(left: "Matrix", right: "grid of numbers"),
        RevisionPair(left: "Row", right: "horizontal line"),
        RevisionPair(left: "Column", right: "vertical line"),
        RevisionPair(left: "2 × 3", right: "2 rows and 3 columns"),
        RevisionPair(left: "Matrix addition", right: "add matching positions"),
        RevisionPair(left: "2A", right: "multiply every number by 2")
    ]
    
    // Варианты справа вынесены отдельно, чтобы порядок ответов отличался от порядка правильных пар
    let rightOptions = [
        "grid of numbers",
        "multiply every number by 2",
        "horizontal line",
        "2 rows and 3 columns",
        "vertical line",
        "add matching positions"
    ]
    
    var body: some View {
        // Использую тот же reusable matching game component, что и в revision по производным
        FormulaMatchingGameView(
            title: "Matrix revision!",
            instruction: "Tap a term, then tap its meaning.",
            pairs: pairs,
            rightOptions: rightOptions,
            buttonTitle: "Back!",
            destination: AnyView(LinearAlgebraView())
        )
    }
}

#Preview {
    NavigationStack {
        MatrixRevisionView()
    }
}
