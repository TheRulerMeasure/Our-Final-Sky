extends Node

export var on_signal: String
export var target_path: NodePath
export var target_method: String
export var params := []
export(int, FLAGS, "Deffered", "Persist", "Oneshot", "Reference Counted") var connect_flag: int = 0

func _ready() -> void:
    var _c := get_parent().connect(
        on_signal, get_node(target_path), target_method, params, connect_flag
    )
