extends TileMap
class_name MapGenerator

signal added_collectable(collectable: Collectable)

const world_gen_passes = 10

var sections: Array[Section] = []

@export var collectable: PackedScene

func point_in_any_section(point: Vector2i) -> bool:
    for section in sections:
        if section.point_in_bounds(point):
            return true
    return false

func rect_in_any_section(rect: Rect2i) -> bool:
    for section in sections:
        if section.rect_in_bounds(rect):
            return true
    return false

class Section:
    enum Direction {
        Left,
        Right,
        Up,
        Down
    }

    func direction_of_int(i: int) -> Direction:
        match i:
            0: return Direction.Left
            1: return Direction.Right
            2: return Direction.Up
            3: return Direction.Down
            _: return direction_of_int(i % 4)
    
    func vector_of_direction(direction: Direction) -> Vector2i:
        match direction: 
            Direction.Left: return Vector2i(-1, 0)
            Direction.Right: return Vector2i(1, 0)
            Direction.Up: return Vector2i(0, -1)
            Direction.Down: return Vector2i(0, 1)
        return Vector2i()
    
    var bounds: Rect2i # = [x, y, width, height]
    var children: Array[Section]
    func _init(bounds: Rect2i):
        self.bounds = bounds
        self.children = []
    
    func point_in_bounds(point: Vector2i) -> bool:
        return bounds.has_point(point)
    
    func rect_in_bounds(rect: Rect2i) -> bool:
        return bounds.intersects(rect)
    
    func make_children(map: MapGenerator, sections: Array[Section]):
        # determine how many children we will have
        var children_count = randi_range(1, 4)
        # try to make a child on each side
        var counter := 0
        var banned_directions := {}
        
        while banned_directions.size() < 4 and children.size() < children_count:
            var direction := direction_of_int(counter)
            var pattern := map.get_random_section()
            var pattern_size := pattern.get_size()
            var pattern_position := Vector2i()
            
            var entrance := Vector2i()
            
            # calculate the other pattern's position
            match direction:
                Direction.Left: 
                    entrance = Vector2i(bounds.position.x, bounds.position.y + ((bounds.size.y - 6) / 2))
                    pattern_position = Vector2i(entrance.x - pattern_size.x, entrance.y - ((pattern_size.y - 6) / 2))
                Direction.Right: 
                    entrance = Vector2i(bounds.position.x, bounds.position.y + ((bounds.size.y - 6) / 2))
                    pattern_position = Vector2i(entrance.x, entrance.y - ((pattern_size.y - 6) / 2))
                Direction.Up: 
                    entrance = Vector2((bounds.position.x + (bounds.size.x - 6) / 2), bounds.position.y)
                    pattern_position = Vector2i(entrance.x - ((pattern_size.x - 6) / 2), entrance.y - pattern_size.y)
                Direction.Down: 
                    entrance = Vector2((bounds.position.x + (bounds.size.x - 6) / 2), bounds.position.y)
                    pattern_position = Vector2i(entrance.x - ((pattern_size.x - 6) / 2), entrance.y)
            counter += 1
            var pattern_rect := Rect2i(pattern_position, pattern_size)
            # check for collisions
            if map.rect_in_any_section(pattern_rect):
                banned_directions[direction] = true
                #print("Adding a child had a collision failure")
            else:
                # move pattern over this section
                pattern_position -= vector_of_direction(direction)
                pattern_rect.position -= vector_of_direction(direction)
                # add pattern to map
                map.set_pattern(0, pattern_position, pattern)
                # bust open the entrance
                for i in range(1,5):
                    match direction:
                        Direction.Left, Direction.Right: map.erase_cell(0, Vector2i(entrance.x, entrance.y + i))
                        Direction.Up, Direction.Down: map.erase_cell(0, Vector2i(entrance.x + i, entrance.y))
                # add pattern to children
                var section = Section.new(pattern_rect)
                children.append(section)
                map.sections.append(section)
                # draw debug line
                #var line = Line2D.new()
                #line.add_point(map.map_to_local(bounds.position))
                #line.add_point(map.map_to_local(pattern_rect.position))
                #map.add_child(line)
                #print("Adding a child succedded!")

func _ready():
    clear()
    
    var pattern = get_random_section()
    var pattern_rect = Rect2i(Vector2i(), pattern.get_size())
    var section = Section.new(pattern_rect)
    set_pattern(0, Vector2i(), pattern)
    sections.append(section)
    
    for i in range(world_gen_passes):
        var sections_length = sections.size()
        for index in range(sections_length):
            sections[index].make_children(self, sections)
    
    # collect all of the collectable spawn points
    var cells: Array[Vector2i] = get_used_cells(0)
    var collectable_spawners: Array[Vector2i] = cells.filter(
        func(cell_pos: Vector2i) -> bool: 
            var cell_id = get_cell_source_id(0, cell_pos)
            return cell_id == 1
    )
    for _i in range(GlobalConstants.max_collectables):
        var index := randi_range(0, collectable_spawners.size() - 1)
        var cell_pos := collectable_spawners[index]
        erase_cell(0, cell_pos)
        var pos = map_to_local(cell_pos)
        
        var c: Collectable = collectable.instantiate()
        c.position = position + pos
        get_parent().add_child.call_deferred(c)
        added_collectable.emit(c)
        
        collectable_spawners.pop_at(index)
    
    # cleanup the rest of the cell tiles
    for cell_pos in collectable_spawners:
        erase_cell(0, cell_pos)

func get_random_section() -> TileMapPattern:
    #return get_random_section_of_size(get_random_size())
    return tile_set.get_pattern(randi_range(0, tile_set.get_patterns_count() - 1))
