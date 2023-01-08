extends Node

signal plane_died
signal plane_destroyed_count_changed(count, mob_count)
signal plane_count_changed(count)
signal display_lower_left_label(node_rid, text, delay_percent, delay_before_remove)
signal round_count_changed(index, rounds)
signal round_reload_time(index, seconds)
signal slot_set_active(index, active)
signal label_done_display(node_rid)

var bullets_node_path: NodePath
var destroyed_planes_count: int = 0
var mob_len: int = 0

onready var bullet_packed: PackedScene = preload("res://scenes/projectiles/Bullet.tscn")
onready var shell_packed: PackedScene = preload("res://scenes/projectiles/Shell.tscn")


func get_ui_planes_stats() -> Control:
    return get_tree().current_scene.get_node("UI/UIPlanesStats") as Control


func get_ui_slot_label() -> Control:
    return get_tree().current_scene.get_node("UI/UISlotLabel") as Control


func init_mob_count(amount: int) -> void:
    mob_len = amount
    get_ui_planes_stats().call("change_destroyed_targets_count", mob_len, 0)


func init_slot_active(index: int, active: bool) -> void:
    get_ui_slot_label().call("_on_slot_set_active", index, active)


func init_slot_rounds(index: int, rounds: int) -> void:
    get_ui_slot_label().call("_on_round_count_changed", index, rounds)


func _on_shooter_shoot(shoot_pos: Vector2, shoot_dir: Vector2) -> void:
    if not bullets_node_path:
        return
    var bullet := bullet_packed.instance()
    bullet.position = shoot_pos
    bullet.motion = shoot_dir*1.2
    get_node(bullets_node_path).add_child(bullet)


func _on_shooter_shoot_timed_shell(shoot_pos: Vector2, shoot_dir: Vector2, distance: float) -> void:
    if not bullets_node_path:
        return
    var shell := shell_packed.instance()
    shell.shell_type = 0
    var dist := distance*0.02
    shell.time_seconds = dist
    shell.position = shoot_pos
    shell.motion = shoot_dir*50
    get_node(bullets_node_path).add_child(shell)


func _on_shooter_shoot_vt_shell(shoot_pos: Vector2, shoot_dir: Vector2) -> void:
    if not bullets_node_path:
        return
    var shell := shell_packed.instance()
    shell.shell_type = 1
    shell.position = shoot_pos
    shell.motion = shoot_dir*50
    get_node(bullets_node_path).add_child(shell)


func _on_plane_count_changed(count: int) -> void:
    emit_signal("plane_count_changed", count)


func _on_plane_died() -> void:
    emit_signal("plane_died")


func _on_LowerLeftLabel_display_label(
    node_rid: int,
    text: String,
    delay_percent: float,
    delay_before_remove: float
) -> void:
    emit_signal("display_lower_left_label", node_rid, text, delay_percent, delay_before_remove)


func _on_spawned_all_mob() -> void:
    print("all planes has spawned")


func _on_plane_destroyed() -> void:
    destroyed_planes_count += 1
    emit_signal("plane_destroyed_count_changed", destroyed_planes_count, mob_len)
    if destroyed_planes_count >= mob_len:
        print("all Planes destroyed")


func _on_reset_stat() -> void:
    mob_len = 0
    destroyed_planes_count = 0


func _on_TG_slot_active(index: int, active: bool) -> void:
    emit_signal("slot_set_active", index, active)


func _on_TG_round_count_changed(index: int, rounds: int) -> void:
    emit_signal("round_count_changed", index, rounds)


func _on_TG_reload_time(index: int, seconds: float) -> void:
    emit_signal("round_reload_time", index, seconds)


func _on_UILabel_done_display(node_rid: int) -> void:
    emit_signal("label_done_display", node_rid)


func _on_change_level(filename: String) -> void:
    var error := get_tree().change_scene(filename)
    assert(error == OK)
