extends CharacterBody2D

func _on_catch_area_area_entered(area: Area2D) -> void:
	print("Body entered: ", area.name)
	if area.is_in_group("spear"):
		print("found spear!")
		print("catch fish!")
		queue_free()
	else:
		print("doesnt detect spear")
