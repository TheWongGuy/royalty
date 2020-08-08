extends Camera2D

var drag = false
var initPosCam = false
var initPosMouse = false
var initPosNode = false


#Input handler, listen for ESC to exit app
func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_W:
				position = get_camera_position() + Vector2(0, -30)
			KEY_S:
				position = get_camera_position() + Vector2(0, 30)
			KEY_A:
				position = get_camera_position() + Vector2(-20, 0)
			KEY_D:
				position = get_camera_position() + Vector2(20, 0)

	if event is  InputEventMouseButton:
		if (event.button_index == BUTTON_WHEEL_UP):
			zoom[0] = zoom[0] + 0.25
			zoom[1] = zoom[1] + 0.25
		if (event.button_index == BUTTON_WHEEL_DOWN):
			if(zoom[0] - 0.25 > 0 && zoom[1] - 0.25 > 0):
				zoom[0] = zoom[0] - 0.25
				zoom[1] = zoom[1] - 0.25
		set_zoom(zoom)
