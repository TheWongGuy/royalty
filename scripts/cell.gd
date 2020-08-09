extends Node2D

class_name Cell

enum Type {
	WATER = 2
	LAND = 1
	VILLAGE = 3
}

var location : Vector2
var type : int 
var height : int # TODO: Implement perlin noise height?
var land_mass # reference to land mass of current cell

var land_neighbour_count : int = 0
var neighbours = []

func set_neighbours(neighbours):
	self.neighbours = neighbours
	for neighbour in neighbours:
		if neighbour.type == Type.LAND:
			land_neighbour_count += 1

func interate_cell():
	if land_neighbour_count < 4:
		if type == Type.LAND:
			for neighbour in neighbours:
				neighbour.land_neighbour_count -= 1
		type = Type.WATER
	elif land_neighbour_count > 4:
		if type == Type.WATER:
			for neighbour in neighbours:
				neighbour.land_neighbour_count += 1
			# Add to neigbours
		type = Type.LAND

func  _init(location : Vector2, type : int):
	self.location = location
	self.type = type

func draw() -> void:
	match type:
		Type.VILLAGE:
			Global.map.civilization_map.set_cellv(location, type)
		_:
			Global.map.tile_map.set_cellv(location, type)

