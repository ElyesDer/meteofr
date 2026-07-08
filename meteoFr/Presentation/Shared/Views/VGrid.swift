//
//  VGrid.swift
//  OutcomeView
//
//  Created by Elyes Derouiche on 27/03/2023.
//

import SwiftUI

public enum GridRow {
    case fixed(ratio: CGFloat, height: CGFloat?, alignment: Alignment?)
    case `default`

    var alignment: Alignment? {
        switch self {
        case .fixed(_,_, let alignment):
            return alignment
        case .default:
            return .center
        }
    }

    static var Default: GridRow {
        return GridRow.default
    }
}

public enum GridMode {
    case fill
    case scroll(Axis.Set)
}

extension VGrid where ActionContent == EmptyView {

    init(
        _ data: Data,
        configuration: GridRowConfiguration,
        vSpacing: CGFloat = 5,
        hSpacing: CGFloat? = nil,
        viewMode: GridMode = .fill,
        @ViewBuilder content: @escaping (Data.Element.Element) -> Content
    ) {
        self.init(data, configuration: configuration, truncateAt: nil, expandedContent: { EmptyView() }, content: content)
    }
}

/// A grid that displays a collection of data with configurable layout.
///
/// `VGrid` arranges data elements in a vertical grid with a customizable layout
/// using a `GridRowConfiguration` matrix that contains the size ratios for each cell
/// in the grid. The content of each cell is provided by a closure passed to the
/// `content` parameter. When the `isExpanded` binding is set to `true`, all
/// elements in the data collection will be displayed. Otherwise, only the first
/// `truncateAt` elements will be displayed. An optional closure passed to the
/// `expandedContent` parameter is displayed below the grid and can be used to
/// toggle the `isExpanded` binding. The `hSpacing` and `vSpacing` parameters can
/// be used to customize the horizontal and vertical spacing between cells.
///
/// Example usage:
///
/// ```swift
/// struct MyData: Identifiable, Hashable {
///     let id: UUID = UUID()
///     let name: String
/// }
///
/// let data = [
///     [MyData(name: "A"), MyData(name: "B"), MyData(name: "C")],
///     [MyData(name: "D"), MyData(name: "E"), MyData(name: "F")],
///     [MyData(name: "G"), MyData(name: "H"), MyData(name: "I")]
/// ]
///
/// let configuration: VGrid<MyData, Text, Empty>.GridConfiguration = [
///     [.fixed(ratio: 0.333), .fixed(ratio: 0.333), .fixed(ratio: 0.333)],
///     [.fixed(ratio: 0.4), .fixed(ratio: 0.4), .fixed(ratio: 0.2)],
///     [.fixed(ratio: 1)]
/// ]
///
/// var body: some View {
///     VGrid(data, configuration: configuration) { data in
///         Text(data.name)
///     }
/// }
/// ```
///
/// - Parameters:
///   - data: A collection of data elements to display in the grid.
///   - configuration: A matrix that defines the size ratios for each cell in the grid.
///   - vSpacing: The vertical spacing between cells in the grid.
///   - hSpacing: The horizontal spacing between cells in the grid. If `nil`, the spacing from the corresponding `GridRow` configuration is used.
///   - viewMode: The view mode for the grid. Defaults to `.fill`.
///   - truncateAt: The maximum number of elements to display in the grid when `isExpanded` is `false`. Defaults to `nil`.
///   - isExpanded: A binding that controls whether all elements in `data` are displayed. Defaults to `true`.
///   - expandedContent: A closure that provides a view to display below the grid when `isExpanded` is `true`.
///   - content: A closure that provides a view for each data element in the grid.
struct VGrid<Data, Content, ActionContent>: View where Data: RandomAccessCollection, Content: View, ActionContent: View, Data.Element: RandomAccessCollection & Hashable, Data.Element.Element: Hashable {

    typealias GridRowConfiguration = [[GridRow]]

    // MARK: Private properties
    @Binding public var isExpanded: Bool

    @State
    private var contentHeight = CGFloat(100)

    private let viewMode: GridMode = .fill
    private let data: Data
    private let configuration: GridRowConfiguration
    private var truncateAt: Int? = 0
    private var vSpacing: CGFloat = 0.0
    private var hSpacing: CGFloat = 0.0
    private let content: (Data.Element.Element) -> Content
    private let expandedContent: () -> ActionContent

    private var scrollAxis: Axis.Set {
        switch self.viewMode {
        case .fill:
            return []
        case .scroll(let axis):
            return axis
        }
    }

    public init(
        _ data: Data,
        configuration: GridRowConfiguration,
        vSpacing: CGFloat = 5,
        hSpacing: CGFloat = 0,
        viewMode: GridMode = .fill,
        truncateAt: Int?,
        isExpanded: Binding<Bool> = .constant(true),
        @ViewBuilder expandedContent: @escaping () -> ActionContent,
        @ViewBuilder content: @escaping (Data.Element.Element) -> Content
    ) {
        self.configuration = configuration
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.data = data
        self.truncateAt = truncateAt
        self._isExpanded = isExpanded
        self.expandedContent = expandedContent
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: vSpacing) {
                let data = Array(data.prefix(isExpanded ? truncateAt : nil).enumerated())
                ForEach(data, id: \.element) { rIndex, row in
                    HStack(spacing: hSpacing) {
                        ForEach(Array(row.enumerated()), id: \.element) { cIndex, item in
                            let configuration = getConfiguration(from: rIndex, y: cIndex)
                            content(item)
                                .frame(
                                    configuration: configuration,
                                    gMetrics: geo.size,
                                    rowItemsCount: row.count,
                                    spacing: hSpacing
                                )
                                .border(Color.red, width: 2)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }

                if let truncateAt, data.count > truncateAt {
                    expandedContent()
                        .animation(.easeInOut(duration: 0.5))
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                }
            }
            .frame(width: geo.size.width)
            .overlay(GeometryReader { gp -> Color in
                DispatchQueue.main.async {
                    withAnimation {
                        self.contentHeight = gp.size.height
                    }
                }
                return Color.clear
            })
        }
        .frame(height: contentHeight)
        //        .border(.blue)
    }

    private func getConfiguration(from x: Int, y: Int) -> GridRow {
        guard x < configuration.count else {
            if y == 0 {
                return configuration.last?.first ?? .Default
            } else {
                return configuration.last?[safeIndex: y] ?? configuration.last?.last ?? GridRow.Default
            }
        }
        let row = configuration[x]
        guard y < row.count else {
            return row.last ?? GridRow.Default
        }
        return row[y]
    }
}

extension RandomAccessCollection {
    public func prefix(_ maxLength: Int?) -> SubSequence {
        if let maxLength {
            return self.prefix(maxLength)
        } else {
            return self.prefix(count)
        }
    }
}

extension View {

    @ViewBuilder
    fileprivate func frame(
        configuration: GridRow,
        gMetrics: CGSize,
        rowItemsCount: Int,
        spacing: CGFloat = 0
    ) -> some View {
        switch configuration {
        case .fixed(let ratio, let height, let alignment):
            let computedWidth = ((gMetrics.width - ((spacing * CGFloat(rowItemsCount - 1)) - 0)) * ratio)
            if let height {
                frame(width: computedWidth, height: height, alignment: alignment ?? .center)
            } else {
                frame(width: computedWidth, alignment: alignment ?? .center)
                    .frame(maxHeight: .infinity, alignment: alignment ?? .center)
            }
        case .default:
            frame(width: nil, height: nil)
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}


struct VGrid_Previews: PreviewProvider {

    static var previews: some View {

        var isExpanded: Bool = false

        let contentX: [[String]] = [
            ["4","15","333333333333333333333333333333333"],
            ["4","15","333333333333333333333333333333333"],
        ]

        let containers: [[GridRow]] = [
            [
                .fixed(
                    ratio: 0.33,
                    height: 200,
                    alignment: .bottom
                ),
                .fixed(
                    ratio: 0.33,
                    height: 200,
                    alignment: .bottom
                ),
                .fixed(
                    ratio: 0.33,
                    height: 200,
                    alignment: .bottom
                ),
            ],
            //                .fixed(
            //                    ratio: 0.33,
            //                    spacing: 0,
            //                    height: nil, //100,
            //                    alignment: .bottom
            //                ),
            //                .fixed(
            //                    ratio: CGFloat(1.0 / Double(contentX[0].count)),
            //                    spacing: 0,
            //                    height: nil,
            //                    alignment: .bottom
            //                )
            //            [
            //                .fixed(ratio: 0.4, height: 80, alignment: .center),
            //                .fixed(ratio: 0.3, height: 40, alignment: .top),
            //            ],
            //            [
            //                .fixed(ratio: 0.2, height: 40, alignment: .leading),
            //                .fixed(ratio: 0.1, height: 40, alignment: .bottom),
            //            ]
        ]

        ScrollView {
            //            Bra()

            VStack {
                StatefulPreviewWrapper(isExpanded) { value in
                    VGrid(contentX,
                          configuration: containers,
                          vSpacing: 10,
                          hSpacing: 15,
                          truncateAt: 1,
                          isExpanded: value,
                          expandedContent: {

                        MoreLessButton(showingMore: value)
                            .overlay(Rectangle()
                                .fill(Color.blue)
                                .frame(maxHeight: 1), alignment: .top)

                    }) { item in
                        Text("Bro \(item)")
                            .frame(alignment: .bottom)
                            .border(Color.red, width: 2)
                    }
                    //                    .border(Color.blue, width: 1)
                }
            }
            //            .frame(width: 300)
        }
    }
}

public struct MoreLessButton: View {

    @State private var text = "More"
    @Binding var showingMore: Bool

    public init(showingMore: Binding<Bool>) {
        self._showingMore = showingMore
    }

    public var body: some View {

        Text(text)
            .border(.blue)
            .frame(height: 47)
            .onChange(of: showingMore) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    text = showingMore ? "Moins" : "Plus"
                }
            }
    }
}

extension Array {

    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }

    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

struct Bra: View {

    @State private var isExpanded = false

    @State private var text: String = "Expand"

    var body: some View {

        VStack {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 200, height: isExpanded ? 300 : 100)
                .animation(.easeInOut(duration: 1))
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        text = isExpanded ? "Not expand" : "Expand"
                    }
                }
            }) {
                Text(text)
                //                        .id("ABC")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .offset(y: isExpanded ? 0 : 0)
                    .animation(.easeInOut(duration: 1))
                //                        .transition(.move(edge: .bottom).combined(with: .slide))
            }
        }
    }
}
