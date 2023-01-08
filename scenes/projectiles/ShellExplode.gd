extends Area2D

export var shell_dead: bool = false setget shell_dead_set


func _ready():
    var _c = connect("body_entered", self, "_on_body_entered")
    $AnimationPlayer.play("explode")


func shell_dead_set(dead: bool) -> void:
    if dead:
        queue_free()


func _on_body_entered(body: Node) -> void:
    if body.is_in_group("plane"):
        body.call("damage", 10)
