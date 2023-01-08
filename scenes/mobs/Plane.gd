extends KinematicBody2D

signal plane_died
signal plane_destroyed

var motion: Vector2 = Vector2.ZERO
var gravity: float = 0.0

export var health: int = 7
export var speed: float = 15


func _ready() -> void:
    motion = Vector2.LEFT*speed
    var _c := $VisibilityNotifier2D.connect("screen_exited", self, "_on_exit_screen")
    _c = connect("plane_died", GameGlobal, "_on_plane_died")
    _c = connect("plane_destroyed", GameGlobal, "_on_plane_destroyed")


func _physics_process(delta: float) -> void:
    motion = Vector2(motion.x, motion.y + gravity*delta)
    var _vec2 := move_and_slide(motion, Vector2.UP)


func damage(amount: int) -> void:
    if health <= 0:
        return
    health -= amount
    if health <= 0:
        die()


func _on_exit_screen() -> void:
    if health > 0:
        emit_signal("plane_died")
    queue_free()


func die():
    set_collision_layer_bit(0, false)
    set_collision_mask_bit(2, false)
    $Particles2D.emitting = true
    $Tween.interpolate_property(
        self, "gravity", 0.0, 5.0, 2.7, Tween.TRANS_LINEAR
    )
    $Tween.start()
    emit_signal("plane_destroyed")
    emit_signal("plane_died")
