extends Area2D

export(int, "timed", "vt") var shell_type: int = 0

var time_seconds: float = 7.2
var motion: Vector2 = Vector2.ZERO

onready var shell_explode_packed := preload("res://scenes/projectiles/ShellExplode.tscn")


func _ready() -> void:
    $Sprite.look_at(to_global(motion))
    var _c := $Timer.connect("timeout", self, "_on_timeout")
    $Timer.call_deferred("start", time_seconds)

    if shell_type == 0:
        $CollisionShape2D.set_deferred("disabled", true)
        return

    _c = self.connect("body_entered", self, "_on_body_entered")


func _physics_process(delta: float) -> void:
    if motion.is_equal_approx(Vector2.ZERO):
        return
    position += motion*delta


func _on_body_entered(body: Node) -> void:
    if body.is_in_group("plane"):
        explode()


func explode() -> void:
    var shell_explode := shell_explode_packed.instance()
    shell_explode.position = position
    get_parent().call_deferred("add_child", shell_explode)
    queue_free()


func _on_timeout() -> void:
    explode()
