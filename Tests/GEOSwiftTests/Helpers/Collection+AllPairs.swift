extension Collection {
    var allPairs: [(Element, Element)] {
        var result = [(Element, Element)]()
        for e1 in self {
            for e2 in self {
                result.append((e1, e2))
            }
        }
        return result
    }
}
