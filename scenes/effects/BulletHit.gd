extends Node2D


func _ready() -> void:
    var _c = $Timer.connect("timeout", self, "_on_timeout")


func _on_timeout() -> void:
    queue_free()
