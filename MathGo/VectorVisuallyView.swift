import SwiftUI

struct VectorVisuallyView: View {
    // Значения координат вектора, которые пользователь меняет через Slider
    @State private var xValue: Double = 3
    @State private var yValue: Double = 2
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Vector = movement")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            // Canvas использую для отрисовки координатной плоскости и самого вектора
            Canvas { context, size in
                let width = size.width
                let height = size.height
                
                let scale: CGFloat = 35
                let origin = CGPoint(x: width / 2, y: height / 2)
                
                // Перевожу математические координаты в координаты экрана
                func point(x: Double, y: Double) -> CGPoint {
                    CGPoint(
                        x: origin.x + CGFloat(x) * scale,
                        y: origin.y - CGFloat(y) * scale
                    )
                }
                
                // Сетка нужна, чтобы движение вектора по координатам было понятнее
                for i in -5...5 {
                    var vertical = Path()
                    vertical.move(to: point(x: Double(i), y: -5))
                    vertical.addLine(to: point(x: Double(i), y: 5))
                    
                    context.stroke(
                        vertical,
                        with: .color(.gray.opacity(0.25)),
                        lineWidth: 1
                    )
                    
                    var horizontal = Path()
                    horizontal.move(to: point(x: -5, y: Double(i)))
                    horizontal.addLine(to: point(x: 5, y: Double(i)))
                    
                    context.stroke(
                        horizontal,
                        with: .color(.gray.opacity(0.25)),
                        lineWidth: 1
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
                    lineWidth: 2
                )
                
                // Конец вектора зависит от текущих xValue и yValue
                let end = point(x: xValue, y: yValue)
                
                var vector = Path()
                vector.move(to: origin)
                vector.addLine(to: end)
                
                context.stroke(
                    vector,
                    with: .color(.blue),
                    lineWidth: 5
                )
                
                // Отдельно считаю стрелку, чтобы было видно направление вектора
                let angle = atan2(end.y - origin.y, end.x - origin.x)
                let arrowLength: CGFloat = 16
                let arrowAngle: CGFloat = .pi / 7
                
                let arrowPoint1 = CGPoint(
                    x: end.x - arrowLength * cos(angle - arrowAngle),
                    y: end.y - arrowLength * sin(angle - arrowAngle)
                )
                
                let arrowPoint2 = CGPoint(
                    x: end.x - arrowLength * cos(angle + arrowAngle),
                    y: end.y - arrowLength * sin(angle + arrowAngle)
                )
                
                var arrowHead = Path()
                arrowHead.move(to: end)
                arrowHead.addLine(to: arrowPoint1)
                arrowHead.move(to: end)
                arrowHead.addLine(to: arrowPoint2)
                
                context.stroke(
                    arrowHead,
                    with: .color(.blue),
                    lineWidth: 5
                )
                
                // Точка показывает конец вектора на плоскости
                context.fill(
                    Path(ellipseIn: CGRect(
                        x: end.x - 6,
                        y: end.y - 6,
                        width: 10,
                        height: 10
                    )),
                    with: .color(.black)
                )
            }
            .frame(height: 300)
            .background(Color.white)
            .border(Color.black, width: 3)
            
            // Координаты обновляются сразу после изменения Slider
            Text("Vector: (\(Int(xValue)), \(Int(yValue)))")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)
                .formulaBoxStyle()
            
            Text("Move \(Int(xValue)) right and \(Int(yValue)) up")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            // Пользователь меняет координаты вектора и сразу видит результат на графике
            VStack(spacing: 10) {
                Text("x: \(Int(xValue))")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                Slider(value: $xValue, in: -4...4, step: 1)
                
                Text("y: \(Int(yValue))")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                Slider(value: $yValue, in: -4...4, step: 1)
            }
            .padding(.horizontal, 20)
        }
        .padding()
    }
}

#Preview {
    VectorVisuallyView()
}
