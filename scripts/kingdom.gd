extends Node2D
class_name Kingdom

export(Vector2) var location
export(int) var population
export(int) var gold
export(String) var cityname

var kingdommap

static func generate_name() -> String:
	var prefix = Global.CITY_NAME_PREFIXES[randi() % len(Global.CITY_NAME_PREFIXES)]
	var suffix = Global.CITY_NAME_SUFFIXES[randi() % len(Global.CITY_NAME_SUFFIXES)]
	var ending = ""
	var ending_chance = randi() % 100
	if ending_chance < 50:
		ending = " " + Global.CITY_NAME_ENDINGS[randi() % len(Global.CITY_NAME_ENDINGS)]
	return prefix + suffix + ending
	
func _ready():
	print(location)
	kingdommap = get_parent().get_node("KingdomMap")
	kingdommap.set_cell(location.x, location.y, Global.TILE_TYPE.VILLAGE)
	
func _init(cityname: String, location : Vector2):
	self.cityname = cityname
	self.location = location
	gold = 100
	population = 5
	var message = "New Kingdom Constructed: City Name = {cityname}, Location = {location}, Population = {population}, Gold = {gold}"
	message = message.format({"cityname": cityname, "location": location, "population": population, "gold": gold})
	print(message)
