import SwiftUI

struct IntegralGraphView: View {
    @State private var endX: Double = 2.0
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Integral = area under the curve")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            // Canvas использую для отрисовки графика функции и площади под кривой
            Canvas { context, size in
                let width = size.width
                let height = size.height
                
                let scale: CGFloat = 45
                let origin = CGPoint(x: width * 0.18, y: height * 0.82)
                
                // Перевожу математические координаты в координаты экрана
                func graphPoint(x: Double, y: Double) -> CGPoint {
                    CGPoint(
                        x: origin.x + CGFloat(x) * scale,
                        y: origin.y - CGFloat(y) * scale
                    )
                }
                
                var axes = Path()
                axes.move(to: CGPoint(x: 0, y: origin.y))
                axes.addLine(to: CGPoint(x: width, y: origin.y))
                axes.move(to: CGPoint(x: origin.x, y: 0))
                axes.addLine(to: CGPoint(x: origin.x, y: height))
                
                context.stroke(
                    axes,
                    with: .color(.gray),
                    lineWidth: 1
                )
                
                // Функция, для которой показываю площадь под графиком
                func f(_ x: Double) -> Double {
                    x * x + 1
                }
                
                // Закрашенная область показывает значение интеграла от 0 до выбранной точки
                var area = Path()
                area.move(to: graphPoint(x: 0, y: 0))
                
                for x in stride(from: 0.0, through: endX, by: 0.02) {
                    area.addLine(to: graphPoint(x: x, y: f(x)))
                }
                
                area.addLine(to: graphPoint(x: endX, y: 0))
                area.closeSubpath()
                
                context.fill(
                    area,
                    with: .color(.blue.opacity(0.25))
                )
                
                // Красная линия показывает сам график функции
                var curve = Path()
                var firstPoint = true
                
                for x in stride(from: -0.5, through: 3.2, by: 0.02) {
                    let y = f(x)
                    let point = graphPoint(x: x, y: y)
                    
                    if firstPoint {
                        curve.move(to: point)
                        firstPoint = false
                    } else {
                        curve.addLine(to: point)
                    }
                }
                
                context.stroke(
                    curve,
                    with: .color(.red),
                    lineWidth: 4
                )
                
                // Левая граница области интегрирования
                var startLine = Path()
                startLine.move(to: graphPoint(x: 0, y: 0))
                startLine.addLine(to: graphPoint(x: 0, y: f(0)))
                
                context.stroke(
                    startLine,
                    with: .color(.black),
                    lineWidth: 2
                )
                
                // Правая граница двигается вместе со Slider
                var endLine = Path()
                endLine.move(to: graphPoint(x: endX, y: 0))
                endLine.addLine(to: graphPoint(x: endX, y: f(endX)))
                
                context.stroke(
                    endLine,
                    with: .color(.black),
                    lineWidth: 2
                )
            }
            .frame(height: 300)
            .background(Color.white)
            .border(Color.black, width: 3)
            
            Text("f(x) = x² + 1")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            Text("Area from x = 0 to x = \(endX, specifier: "%.1f")")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            // Slider позволяет менять правую границу и видеть, как меняется площадь
            Slider(value: $endX, in: 0.3...3.0)
                .padding(.horizontal, 20)
        }
        .padding()
    }
}

#Preview {
    IntegralGraphView()
}
