extends KinematicBody2D

var motion: Vector2
onready var bullet_hit_packed := preload("res://scenes/effects/BulletHit.tscn")


func _ready() -> void:
    var _c := $BulletLifeTimer.connect("timeout", self, "_on_BulletLifeTimer_timeout")
    $Sprite.look_at(to_global(motion))
    $Tween.interpolate_property(
        $Sprite,
        "self_modulate",
        Color(1.0, 1.0, 1.0, 0.0),
        Color.white,
        1.75
    )
    $Tween.start()


func _physics_process(_delta: float) -> void:
    if motion.is_equal_approx(Vector2.ZERO):
        return

    var collide := move_and_collide(motion)
    if collide:
        var collider := collide.collider
        if collider.has_method("damage"):
            collider.call("damage", 1)
        queue_free()
        var bullet_hit = bullet_hit_packed.instance()
        bullet_hit.position = position
        get_parent().add_child(bullet_hit)


func _on_BulletLifeTimer_timeout() -> void:
    queue_free()
