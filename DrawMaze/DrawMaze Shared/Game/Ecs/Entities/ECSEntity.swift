//
// Created by David Kanenwisher on 2/14/23.
//

protocol ECSEntity {
    var id: String { get }

    // components
    var graphics: ECSGraphics { get }
}
