@tool
extends EditorPlugin

func _enter_tree():
	# Add autoload singletons
	add_autoload_singleton("VFX", "res://addons/vfx_library/vfx.gd")
	add_autoload_singleton("EnvVFX", "res://addons/vfx_library/env_vfx.gd")
	print("VFX Library plugin enabled")

func _exit_tree():
	# Remove autoload singletons
	remove_autoload_singleton("VFX")
	remove_autoload_singleton("EnvVFX")
	print("VFX Library plugin disabled")
