extends Node2D

var timeout = false
var timer 
var tile_map
var map

func _ready():
	tile_map = get_parent()
	map = tile_map.get_parent()
	timer = tile_map.get_node("WaterTimer")
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _process(_delta):
	if timeout == true:
		for cell in map.WATER_CELLS: 
			var tile = tile_map.get_cell_autotile_coord(cell.location.x, cell.location.y)
			if(tile == Vector2(1, 1)):
				tile_map.set_cell(cell.location.x, cell.location.y, Cell.Type.WATER, false, false, false, Vector2(2, 1))
			elif(tile == Vector2(2, 1)):
				tile_map.set_cell(cell.location.x, cell.location.y, Cell.Type.WATER, false, false, false, Vector2(1, 1))
		timeout = false
			

func _on_timer_timeout():
	timeout = true
