extends TileMap

export var water_percentage = 50
var map_size = Vector2(50, 50)

const TILE_TYPE = {'WATER': 2, 'LAND': 1}

func generate_world():
	place_cells()
	create_water_border()
	for i in range(4):
		smooth()
	update_bitmask()
	
# Called when the node enters the scene tree for the first time.
func _ready():
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
				set_cell(x, y, TILE_TYPE.WATER)
			else:
				set_cell(x, y, TILE_TYPE.LAND)

func create_water_border():
	for x in map_size.x:
		set_cell(x, 0, TILE_TYPE.WATER)
		set_cell(x, map_size.y, TILE_TYPE.WATER)
		set_cell(x, 1, TILE_TYPE.WATER)
		set_cell(x, map_size.y-1, TILE_TYPE.WATER)
	for y in map_size.y:
		set_cell(0, y, TILE_TYPE.WATER)
		set_cell(map_size.x, y, TILE_TYPE.WATER)
		set_cell(1, y, TILE_TYPE.WATER)
		set_cell(map_size.x-1, y, TILE_TYPE.WATER)
		

		
func smooth():
	for x in range(1, map_size.x-1):
		for y in range(1, map_size.y-1):
			iterate_cell(x, y)
	
func iterate_cell(x, y):
	var cell = get_cell(x, y)
	var cell_counts = get_neighbour_cell_count(x, y)
	
	if cell_counts.WATER_COUNT > 4:
		set_cell(x, y, TILE_TYPE.WATER)
	elif cell_counts.WATER_COUNT < 4:
		set_cell(x, y, TILE_TYPE.LAND)
	
		
func is_channel(x, y):
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
	
	var top_cell = get_cell(x, top_left.y)
	var bottom_cell = get_cell(x, bottom_right.y)
	var left_cell = get_cell(top_left.x, y)
	var right_cell = get_cell(bottom_right.x, y)

	if top_cell == bottom_cell and top_cell == TILE_TYPE.LAND:
		return true	
	if left_cell == right_cell and left_cell == TILE_TYPE.LAND:
		return true
	return false
	
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
			match get_cell(local_x, local_y):
				TILE_TYPE.WATER:
					water_count += 1
				TILE_TYPE.LAND:
					land_count += 1
		
	return {'WATER_COUNT': water_count, 'LAND_COUNT': land_count}
	
func clean_narrow_lakes():
	for x in range(1, map_size.x-1):
		for y in range(1, map_size.y-1):
			var cell = get_cell(x, y)
			if cell == TILE_TYPE.WATER:
				if is_channel(x, y):
					set_cell(x, y, TILE_TYPE.LAND)
			
func update_bitmask():
	update_bitmask_region(Vector2(0, 0), map_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

