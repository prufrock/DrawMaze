//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

struct MapData: Decodable {
    let tiles: [Tile]
    let things: [Thing]?
    let hud: [Tile]
    let width: Int
}
