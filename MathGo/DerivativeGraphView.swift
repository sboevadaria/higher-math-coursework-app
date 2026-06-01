import SwiftUI

struct DerivativeGraphView: View {
    // Значение x, которое пользователь меняет с помощью Slider
    @State private var xValue: Double = 2.0

    var body: some View {
        VStack(spacing: 16) {
            Text("Derivative = slope here")
                .font(.system(size: 18, weight: .regular, design: .rounded))

            // Canvas я использую для ручной отрисовки графика, касательной и точки касания
            Canvas { context, size in
                let width = size.width
                let height = size.height

                let scale: CGFloat = 45
                let origin = CGPoint(x: width / 2, y: height * 0.75)

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

                // Строю график функции f(x) = x²
                var curve = Path()
                var firstPoint = true

                for x in stride(from: -3.0, through: 3.0, by: 0.02) {
                    let y = x * x
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

                // Касательная зависит от текущего значения xValue
                let a = xValue
                let fa = a * a
                let slope = 2 * a

                var tangent = Path()

                let x1 = a - 2
                let x2 = a + 2

                let y1 = slope * (x1 - a) + fa
                let y2 = slope * (x2 - a) + fa

                tangent.move(to: graphPoint(x: x1, y: y1))
                tangent.addLine(to: graphPoint(x: x2, y: y2))

                context.stroke(
                    tangent,
                    with: .color(.blue),
                    lineWidth: 4
                )

                // Точка показывает место, в котором считается производная
                let point = graphPoint(x: a, y: fa)

                context.fill(
                    Path(ellipseIn: CGRect(
                        x: point.x - 6,
                        y: point.y - 6,
                        width: 12,
                        height: 12
                    )),
                    with: .color(.black)
                )
            }
            .frame(height: 300)
            .background(Color.white)
            .border(Color.black, width: 3)

            Text("f(x) = x²")
                .font(.system(size: 18, weight: .regular, design: .rounded))

            // Здесь сразу показывается связь между выбранной точкой и значением наклона
            Text("At x = \(xValue, specifier: "%.1f"), slope = \(2 * xValue, specifier: "%.1f")")
                .font(.system(size: 18, weight: .regular, design: .rounded))

            // Slider позволяет пользователю менять точку на графике и видеть изменение касательной
            Slider(value: $xValue, in: -2.5...2.5)
                .padding(.horizontal, 20)
        }
        .padding()
    }
}

#Preview {
    DerivativeGraphView()
}
