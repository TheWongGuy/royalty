extends Node2D

class_name Map

export var water_percentage = 50
export var map_size = Vector2(500, 500)
export var civilization_count = 3

var tile_map
var civilization_map

const CIVILIZATIONS = []
const LAND_CELLS = []
const WATER_CELLS = []
const CELL_MAP = {}

func get_cell(location : Vector2) -> Cell:
	return CELL_MAP[location] as Cell

func _ready():
	Global.map = self
	tile_map = get_node("TileMap")
	civilization_map = get_node("CivilizationMap")

func generate() -> void:
	_clean_up()
	_generate_cell_map()
	for _i in range(4):
		_smooth()
	_refresh_cell_indexes()
	_draw_map()

func _generate_cell_map() -> void:
	print("Generating Cell Map")
	for x in map_size.x:
		for y in map_size.y:
			var location = Vector2(x, y)
			var cell_type = randi() % 100
			if cell_type < water_percentage:
				CELL_MAP[location] = Cell.new(location, Cell.Type.WATER)
			else:
				CELL_MAP[location] = Cell.new(location, Cell.Type.LAND)
	_create_water_border()
	_update_neighbours()

func _create_water_border() -> void:
	for x in map_size.x:
		get_cell(Vector2(x, 0)).type = Cell.Type.WATER
		get_cell(Vector2(x, 1)).type = Cell.Type.WATER
		get_cell(Vector2(x, map_size.y-1)).type = Cell.Type.WATER
		get_cell(Vector2(x, map_size.y-2)).type = Cell.Type.WATER
	for y in map_size.y:
		get_cell(Vector2(0, y)).type = Cell.Type.WATER
		get_cell(Vector2(1, y)).type = Cell.Type.WATER
		get_cell(Vector2(map_size.x-1, y)).type = Cell.Type.WATER
		get_cell(Vector2(map_size.x-2, y)).type = Cell.Type.WATER
		
func _update_neighbours() -> void:
	for cell in CELL_MAP.values():
		cell.set_neighbours(_get_neighbours(cell.location))
		
func _smooth() -> void:
	for x in range(1, map_size.x-1):
		for y in range(1, map_size.y-1):
			get_cell(Vector2(x, y)).interate_cell()	

# Consider moving this logic into cells, ignoring for now
# This function sucks fix it later.
func _get_neighbours(location : Vector2):
	var top_left = Vector2(location.x-1, location.y-1)
	var bottom_right = Vector2(location.x+1, location.y+1)
	
	var neighbours = []

	for local_x in range(top_left.x, bottom_right.x + 1):
		for local_y in range(top_left.y, bottom_right.y + 1):
			var local_pos = Vector2(local_x, local_y)
			if local_pos == location:
				continue
			if(local_pos.x <= -1 or local_pos.x >= map_size.x or local_pos.y <= -1 or local_pos.y >= map_size.y):
				continue
			neighbours.append(get_cell(local_pos))
	return neighbours
			
func _refresh_cell_indexes() -> void:
	LAND_CELLS.clear()
	WATER_CELLS.clear()
	for cell in CELL_MAP.values():
		cell = cell as Cell
		match cell.type:
			Cell.Type.WATER:
				WATER_CELLS.append(cell)
			Cell.Type.LAND:
				LAND_CELLS.append(cell)
#func refresh_land_tiles():
#	Global.LAND_CELLS.clear()
#	for x in map_size.x:
#		for y in map_size.y:
#			var cell = tilemap.get_cell(x, y)
#			if cell == TILE_TYPE.LAND:
#				Global.LAND_CELLS.append(Vector2(x, y))
#
#func generate_civilizations():
#	refresh_land_tiles()
#	print("Generating Civilzations")
#	for i in civilization_count:
#		generate_civilization()
#		
#func generate_civilization():
#	var index = randi() % len(Global.LAND_CELLS)
#	var cell = Global.LAND_CELLS[index]
#	while(kingdommap.get_cellv(cell) == Global.TILE_TYPE.VILLAGE):
#		index += 1 
#		index = index % len(Global.LAND_CELLS)
#		cell = Global.LAND_CELLS[index]
#		
#	var kingdom = Kingdom.new(Kingdom.generate_name(), cell)
#	Global.KINGDOMS.append(kingdom)
#	add_child(kingdom)
#	
func _draw_map():
	print("Drawing Map")
	for cell in CELL_MAP.values():
		cell.draw()
	_update_bitmask()
	
func _clean_up():
	print("Cleaning Up Cells")
	for cell in CELL_MAP.values():
		cell.free()
	LAND_CELLS.clear()
	WATER_CELLS.clear()
	CELL_MAP.clear()

func _update_bitmask():
	tile_map.update_bitmask_region(Vector2(0, 0), map_size)

func _input(ev):
	var just_pressed = ev.is_pressed() and not ev.is_echo()
	if ev is InputEventKey and ev.scancode == KEY_SPACE and just_pressed:
		generate()
