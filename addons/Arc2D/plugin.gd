@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Arc2D", "Line2D", preload("arc2d.gd"), preload("icon.svg"))


func _exit_tree():
	remove_custom_type("Arc2D")
