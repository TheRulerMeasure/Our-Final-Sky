extends Node2D

export var missile_explode_dead: bool = false setget set_missile_explode_dead


func _ready() -> void:
    $AnimationPlayer.play("explode")


func set_missile_explode_dead(dead: bool) -> void:
    if dead:
        queue_free()
