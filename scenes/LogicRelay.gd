extends Node

signal on_trigger


func trigger() -> void:
    emit_signal("on_trigger")
