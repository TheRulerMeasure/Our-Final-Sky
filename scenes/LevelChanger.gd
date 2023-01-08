extends Node

signal change_level(filename)

export(String, FILE) var new_level_filename


func _ready() -> void:
    var _c := connect("change_level", GameGlobal, "_on_change_level")


func _change_level() -> void:
    emit_signal("change_level", new_level_filename)
