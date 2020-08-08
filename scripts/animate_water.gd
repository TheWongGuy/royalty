extends Node2D

var timeout = false
var timer 
var tilemap

func _ready():
	tilemap = get_parent()
	timer = tilemap.get_node("WaterTimer")
	timer.connect("timeout", self, "_on_timer_timeout")
	
func _process(delta):
	if timeout == true:
		for cell in tilemap.get_used_cells_by_id(Global.TILE_TYPE.WATER):
			var tile = tilemap.get_cell_autotile_coord(cell.x, cell.y)
			if(tile == Vector2(1, 1)):
				tilemap.set_cell(cell.x, cell.y, Global.TILE_TYPE.WATER, false, false, false, Vector2(2, 1))
			elif(tile == Vector2(2, 1)):
				tilemap.set_cell(cell.x, cell.y, Global.TILE_TYPE.WATER, false, false, false, Vector2(1, 1))
		timeout = false
			

func _on_timer_timeout():
	timeout = true
