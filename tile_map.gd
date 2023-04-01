extends TileMap
class_name PatternContainer

enum Size {
	x24,
	x12,
	x18x12,
	x18x24
}

func get_random_size() -> Size:
	return [Size.x24, Size.x12, Size.x18x12, Size.x18x24].pick_random()

func y_offset_of_size(size: Size) -> int:
	match size:
		Size.x24: return 0
		Size.x12: return 24
		Size.x18x12: return 24 + 12
		Size.x18x24: return 24 + 12 + 12
	return 0
	push_error("Failed to match %s in y_offset_of_size" % size)

func width_of_size(size: Size) -> int:
	match size:
		Size.x24: return 24
		Size.x12: return 12
		Size.x18x12: return 18
		Size.x18x24: return 18
	return 0
	push_error("Failed to match %s in width_of_size" % size)

func height_of_size(size: Size) -> int:
	match size:
		Size.x24: return 24
		Size.x12: return 12
		Size.x18x12: return 12
		Size.x18x24: return 24
	return 0
	push_error("Failed to match %s in height_of_size" % size)

func get_section(size: Size, index: int) -> TileMapPattern:
	var width := width_of_size(size)
	var height := height_of_size(size)
	var x := width * index
	var y := y_offset_of_size(size)
	
	return get_pattern(0, [Vector2i(x, y), Vector2i(width, height)])
	
func number_of_sections(size: Size) -> int:
	var y := y_offset_of_size(size)
	var width := width_of_size(size)
	
	var result := 0
	while get_cell_source_id(0, Vector2i(width * result, y)) != -1:
		result += 1
	
	return result

func get_random_section_of_size(size: Size) -> TileMapPattern:
	var section_count = number_of_sections(size)
	assert(section_count > 0)
	var index := randi_range(0, section_count - 1)
	
	return get_section(size, index)
	
func get_random_section() -> TileMapPattern:
	return get_random_section_of_size(get_random_size())
