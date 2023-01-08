extends Node


func _ready() -> void:
    GameGlobal.bullets_node_path = get_parent().get_path()
