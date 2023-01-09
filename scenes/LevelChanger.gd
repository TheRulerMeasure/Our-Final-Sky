extends Node

signal change_level(filename)
signal game_reset_stat

export(String, FILE) var new_level_filename


func _ready() -> void:
    var _c := connect("change_level", GameGlobal, "_on_change_level")
    _c = connect("game_reset_stat", GameGlobal, "_on_reset_stat")


func _change_level() -> void:
    emit_signal("game_reset_stat")
    emit_signal("change_level", new_level_filename)
