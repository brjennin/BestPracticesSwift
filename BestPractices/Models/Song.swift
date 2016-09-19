struct Song {
    private(set) var identifier: Int
    private(set) var name: String
    private(set) var artist: String
    private(set) var url: String
    private(set) var albumArt: String
    
    init(identifier: Int, name: String, artist: String, url: String, albumArt: String) {
        self.identifier = identifier
        self.name = name
        self.artist = artist
        self.url = url
        self.albumArt = albumArt
    }
}
