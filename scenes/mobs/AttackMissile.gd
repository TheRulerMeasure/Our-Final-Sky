extends KinematicBody2D

signal plane_died
signal plane_destroyed

export var health: int = 2
export var speed: float = 37.0

var motion: Vector2 = Vector2.LEFT

onready var missile_explode_packed: PackedScene = preload("res://scenes/effects/MissileExplode.tscn")


func _ready() -> void:
    motion = Vector2.LEFT*speed

    var _c := $VisibilityNotifier2D.connect("screen_exited", self, "_on_screen_exited")
    _c = connect("plane_died", GameGlobal, "_on_plane_died")
    _c = connect("plane_destroyed", GameGlobal, "_on_plane_destroyed")

    $AnimationPlayer.play("flare")


func _process(_delta: float) -> void:
    $Flare.position = $AttackMissile/Position2D.position


func _physics_process(_delta: float) -> void:
    var _vec := move_and_slide(motion, Vector2.UP)


func damage(amount: int) -> void:
    if health <= 0:
        return
    health -= amount
    if health <= 0:
        die()


func die() -> void:
    var missile_explode := missile_explode_packed.instance()
    missile_explode.position = position
    get_parent().call_deferred("add_child", missile_explode)
    emit_signal("plane_destroyed")
    emit_signal("plane_died")
    queue_free()


func _on_screen_exited() -> void:
    if health > 0:
        emit_signal("plane_died")
    queue_free()
