%dw 2.0
import drop from dw::core::Arrays
import lines, words, isNumeric from dw::core::Strings
import mapLeafValues from dw::util::Tree
output application/json
fun getStructure(commandList, structure=[], currentDir="") = do {
    var command = commandList[0]
    @Lazy
    var ncl = commandList drop 1
    @Lazy
    var ls = lines(command) drop 1
    @Lazy
    var newDir = words(command)[-1]
    ---
    if (isEmpty(command))
        structure
    else if (command contains "cd")
        getStructure(
            ncl,
            structure,
            newDir
        )
    else getStructure(
        ncl,
        structure + {
            //isDir: true,
            name: currentDir,
            size: ls 
                map words($)[0] 
                filter isNumeric($)
                then sum($) as Number,
            //ls: ls,
            dirs: ls
                filter ($ contains "dir")
                map words($)[1]
        },
        currentDir
    )
}
var structure = payload splitBy "\n\$" map trim($)
    then getStructure($)
var grouped = structure groupBy $.name 
/*
fun getrecdirs(dirs: Array) = do {
    dirs map (dir) -> do {
        var thisdir = grouped[dir][0]
        ---
        {
            name: thisdir.name,
            size: thisdir.size, //getrecsize(thisdir),
            dirs: getrecdirs(thisdir.dirs)
        }
    }
}
fun getrecsize(dirs: Array) = do {
    dirs map (dir) -> do {
        dir update {
            case .size -> sum(dir..size)
            case .dirs -> getrecsize($)
        } //then getrecsize(dir.dirs)
    }
}*/
---
grouped
/*{
    name: structure[0].name,
    size: sum(structure..size),
    dirs: getrecdirs(structure[0].dirs)
} update {
    case .dirs -> getrecsize($)
}
then $..size 
filter $ <= 100000
then sum($)*/
