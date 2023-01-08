extends Node

signal plane_count_changed(count)
signal spawned_a_mob(count)
signal spawned_all_mob
signal done_spawning_and_no_planes

onready var plane_packed: PackedScene = preload("res://scenes/mobs/Plane.tscn")
onready var attack_missile_packed: PackedScene = preload("res://scenes/mobs/AttackMissile.tscn")

export(String, FILE, "*.json") var plane_spawn_data: String

var spawn_data := {}
var spawned_mob_len: int = 0
var mob_len: int = 0
var current_index: int = 0
var planes_count: int = 0


func _ready() -> void:
    var _c = $SpawnTimer.connect("timeout", self, "_on_SpawnTimer_timeout")

    spawn_data = read_file(plane_spawn_data)
    mob_len = len(spawn_data["spawn_list"])
    current_index = 0
    spawned_mob_len = 0
    $SpawnTimer.start(get_current_spawn_delay())

    _c = GameGlobal.connect("plane_died", self, "_on_plane_died")
    _c = connect("plane_count_changed", GameGlobal, "_on_plane_count_changed")
    _c = connect("spawned_all_mob", GameGlobal, "_on_spawned_all_mob")
    GameGlobal.init_mob_count(mob_len)


func get_current_index() -> Dictionary:
    return spawn_data["spawn_list"][current_index] as Dictionary


func get_current_spawn_delay() -> float:
    return get_current_index()["delay_before_spawning"] as float


func get_current_mob() -> int:
    return get_current_index()["mob"] as int


func get_current_spawn_pos() -> Vector2:
    var spawn_pos := get_current_index()["spawn_pos"] as Dictionary
    return Vector2(spawn_pos["x"], spawn_pos["y"])


func spawn_current_mob() -> void:
    match get_current_mob():
        0:
            spawn_plane(get_current_spawn_pos())
        1:
            spawn_attack_missile(get_current_spawn_pos())

    spawned_mob_len += 1
    emit_signal("spawned_a_mob", spawned_mob_len)
    planes_count += 1
    emit_signal("plane_count_changed", planes_count)

    current_index += 1
    if current_index >= mob_len:
        emit_signal("spawned_all_mob")
        return
    $SpawnTimer.start(get_current_spawn_delay())


func update_planes_count() -> void:
    if planes_count <= 0 and spawned_mob_len >= mob_len:
        emit_signal("done_spawning_and_no_planes")


func read_file(data: String) -> Dictionary:
    var f := File.new()
    var err := f.open(data, File.READ)
    assert(err == OK)
    var json_result: JSONParseResult = JSON.parse(f.get_as_text())
    f.close()
    return json_result.result as Dictionary


func spawn_plane(spawn_pos: Vector2) -> void:
    var plane := plane_packed.instance()
    plane.position = spawn_pos
    get_parent().call_deferred("add_child", plane)


func spawn_attack_missile(spawn_pos: Vector2) -> void:
    var attack_missile = attack_missile_packed.instance()
    attack_missile.position = spawn_pos
    get_parent().call_deferred("add_child", attack_missile)


func _on_SpawnTimer_timeout() -> void:
    spawn_current_mob()


func _on_plane_died() -> void:
    planes_count -= 1
    emit_signal("plane_count_changed", planes_count)
    update_planes_count()
