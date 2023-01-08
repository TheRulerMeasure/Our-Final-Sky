extends Node2D

signal shoot(shoot_pos, shoot_dir)
signal shoot_timed_shell(shoot_pos, shoot_dir, distance)
signal shoot_vt_shell(shoot_pos, shoot_dir)
signal fired

export(int, "bullet", "timed_shell", "vt_shell") var proj_type: int = 0
export(float, 0, 5) var spread: float = 0.07
export(float, 0.07, 3) var reload: float = 0.3
export(float, 0.08, 2) var delay_before_first_shot: float = 0.08

var active := false
var refilling := false
var shootDir: Vector2 = Vector2.UP
var shooting: bool = false
var rand: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
    rand.randomize()
    var _c := connect("shoot", GameGlobal, "_on_shooter_shoot")
    _c = connect("shoot_timed_shell", GameGlobal, "_on_shooter_shoot_timed_shell")
    _c = connect("shoot_vt_shell", GameGlobal, "_on_shooter_shoot_vt_shell")


func _physics_process(delta: float) -> void:
    shootDir = shootDir.slerp(
        position.direction_to(get_global_mouse_position()),
        3.7*delta
    )
    $Sprite.look_at(to_global(shootDir))

    if Input.is_mouse_button_pressed(BUTTON_LEFT) and active and not refilling:
        if not shooting:
            shooting_changed(shooting)
        shooting = true
        if $ShootDelayTimer.is_stopped() and $FirstShotTimer.is_stopped():
            shoot()
    else:
        if shooting:
            shooting_changed(shooting)
        shooting = false


func shoot() -> void:
    var shoot_dir = shootDir.rotated(rand.randf_range(-spread, spread))

    match proj_type:
        0:
            emit_signal("shoot", position, shoot_dir)
        1:
            emit_signal(
                "shoot_timed_shell",
                position,
                shoot_dir,
                position.distance_to(get_global_mouse_position())
            )
        2:
            emit_signal(
                "shoot_vt_shell",
                position,
                shoot_dir
            )
    emit_signal("fired")

    var min_delay := max(reload - rand.randf()*0.2, 0.07)
    var max_delay := reload + reload-rand.randf()*0.2
    $ShootDelayTimer.start(rand.randf_range(min_delay, max_delay))
    $Sprite.frame = rand.randi_range(0, 1)
    $AnimationPlayer.play("flash")


func shooting_changed(v: bool) -> void:
    if not v:
        $FirstShotTimer.start(delay_before_first_shot)


func _on_set_active(v: bool) -> void:
    active = v


func _on_set_refilling(v: bool) -> void:
    refilling = v
