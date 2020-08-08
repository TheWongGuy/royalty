extends Node2D

export var water_percentage = 50
export var map_size = Vector2(25, 25)
export var civilization_count = 3

var TILE_TYPE = Global.TILE_TYPE

var tilemap
var kingdommap

func generate_world():
	_clear_kingdoms()
	print("Generating Map")
	place_cells()
	create_water_border()
	for i in range(4):
		smooth()
	update_bitmask()
	generate_civilizations()


func _clear_kingdoms() -> void:
	for kingdom in Global.KINGDOMS:
		kingdommap.set_cell(kingdom.location.x, kingdom.location.y, -1)
		remove_child(kingdom)
	Global.KINGDOMS.clear()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_node("TileMap")
	kingdommap = get_node("KingdomMap")
	generate_world()
	
func _input(ev):
	var just_pressed = ev.is_pressed() and not ev.is_echo()
	if ev is InputEventKey and ev.scancode == KEY_SPACE and just_pressed:
		generate_world()
		 
func place_cells():
	for x in map_size.x:
		for y in map_size.y:
			var cell_type = randi() % 100
			if cell_type < water_percentage:
				tilemap.set_cell(x, y, TILE_TYPE.WATER)
			else:
				tilemap.set_cell(x, y, TILE_TYPE.LAND)

func create_water_border():
	for x in map_size.x:
		tilemap.set_cell(x, 0, TILE_TYPE.WATER)
		tilemap.set_cell(x, map_size.y, TILE_TYPE.WATER)
		tilemap.set_cell(x, 1, TILE_TYPE.WATER)
		tilemap.set_cell(x, map_size.y-1, TILE_TYPE.WATER)
	for y in map_size.y:
		tilemap.set_cell(0, y, TILE_TYPE.WATER)
		tilemap.set_cell(map_size.x, y, TILE_TYPE.WATER)
		tilemap.set_cell(1, y, TILE_TYPE.WATER)
		tilemap.set_cell(map_size.x-1, y, TILE_TYPE.WATER)
		
func smooth():
	for x in range(1, map_size.x-1):
		for y in range(1, map_size.y-1):
			iterate_cell(x, y)
	
func iterate_cell(x, y):
	var cell = tilemap.get_cell(x, y)
	var cell_counts = get_neighbour_cell_count(x, y)
	
	if cell_counts.WATER_COUNT > 4:
		tilemap.set_cell(x, y, TILE_TYPE.WATER)
	elif cell_counts.WATER_COUNT < 4:
		tilemap.set_cell(x, y, TILE_TYPE.LAND)

# Grabs neighbour cell count including diagonals
func get_neighbour_cell_count(x, y):
	var top_left = Vector2(x-1, y-1)
	var bottom_right = Vector2(x+1, y+1)
	
	if x-1 < 0:
		top_left.x = 0
	if y-1 < 0:
		top_left.y = 0
		
	if x+1 >= map_size.x:
		bottom_right.x = map_size.x - 1
	if y+1 >= map_size.y:
		bottom_right.y = map_size.y - 1
	
	var water_count = 0
	var land_count = 0
	
	for local_x in range(top_left.x, bottom_right.x + 1):
		for local_y in range(top_left.y, bottom_right.y + 1):
			if local_x == x and local_y == y:
				continue
			match tilemap.get_cell(local_x, local_y):
				TILE_TYPE.WATER:
					water_count += 1
				TILE_TYPE.LAND:
					land_count += 1
	return {'WATER_COUNT': water_count, 'LAND_COUNT': land_count}
			
func update_bitmask():
	tilemap.update_bitmask_region(Vector2(0, 0), map_size)

func refresh_land_tiles():
	Global.LAND_CELLS.clear()
	for x in map_size.x:
		for y in map_size.y:
			var cell = tilemap.get_cell(x, y)
			if cell == TILE_TYPE.LAND:
				Global.LAND_CELLS.append(Vector2(x, y))

func generate_civilizations():
	refresh_land_tiles()
	print("Generating Civilzations")
	for i in civilization_count:
		generate_civilization()
		
func generate_civilization():
	var index = randi() % len(Global.LAND_CELLS)
	var cell = Global.LAND_CELLS[index]
	while(kingdommap.get_cellv(cell) == Global.TILE_TYPE.VILLAGE):
		index += 1
		cell = Global.LAND_CELLS[index]
		
	var kingdom = Kingdom.new(Kingdom.generate_name(), cell)
	Global.KINGDOMS.append(kingdom)
	add_child(kingdom)
	

