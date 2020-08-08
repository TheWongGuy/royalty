extends Node2D

var timeout = false
var timer 
var tile_map

func _ready():
	tile_map = get_parent()
	timer = tile_map.get_node("WaterTimer")
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _process(delta):
	if timeout == true:
		for cell in tile_map.get_used_cells_by_id(Cell.Type.WATER):
			var tile = tile_map.get_cell_autotile_coord(cell.x, cell.y)
			if(tile == Vector2(1, 1)):
				tile_map.set_cell(cell.x, cell.y, Cell.Type.WATER, false, false, false, Vector2(2, 1))
			elif(tile == Vector2(2, 1)):
				tile_map.set_cell(cell.x, cell.y, Cell.Type.WATER, false, false, false, Vector2(1, 1))
		timeout = false
			

func _on_timer_timeout():
	timeout = true
