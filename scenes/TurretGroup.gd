extends Node

signal set_turret_active(active)
signal set_turret_refilling(refilling)
signal round_count_changed(index, rounds)
signal round_reload_time(index, current_seconds)
signal slot_set_active(index, active)

export var active_current: bool = false
export(int, 0, 2) var group_index: int = 0
export(int, 1, 39999) var max_rounds: int = 100
export(float, 0.1, 10, 0.2) var reload_time: float = 5.75

var current_rounds: int = 0


func _ready() -> void:
    $ReloadTimer.wait_time = reload_time
    var _c := $ReloadTimer.connect("timeout", self, "_on_ReloadTimer_timeout")

    connect_turrets()
    
    _c = connect("round_count_changed", GameGlobal, "_on_TG_round_count_changed")
    _c = connect("round_reload_time", GameGlobal, "_on_TG_reload_time")
    _c = connect("slot_set_active", GameGlobal, "_on_TG_slot_active")

    current_rounds = max_rounds

    GameGlobal.init_slot_active(group_index, active_current)
    emit_signal("set_turret_active", active_current)
    GameGlobal.init_slot_rounds(group_index, current_rounds)


func _process(_delta: float) -> void:
    var slot: int = -1
    if Input.is_action_just_pressed("slot0"):
        slot = 0
    elif Input.is_action_just_pressed("slot1"):
        slot = 1
    elif Input.is_action_just_pressed("slot2"):
        slot = 2

    if slot >= 0:
        var active := slot == group_index
        emit_signal("set_turret_active", active)
        emit_signal("slot_set_active", group_index, active)

    if not $ReloadTimer.is_stopped():
        emit_signal("round_reload_time", group_index, $ReloadTimer.time_left)


func connect_turrets() -> void:
    var children := get_parent().get_children()
    for i in children:
        if not i.has_signal("fired"):
            continue
        var _c = i.connect("fired", self, "_on_turret_fired")
        _c = connect("set_turret_active", i, "_on_set_active")
        _c = connect("set_turret_refilling", i, "_on_set_refilling")


func _on_turret_fired() -> void:
    current_rounds -= 1
    emit_signal("round_count_changed", group_index, current_rounds)
    if (current_rounds <= 0):
        emit_signal("set_turret_refilling", true)
        $ReloadTimer.start()


func _on_ReloadTimer_timeout() -> void:
    emit_signal("set_turret_refilling", false)
    current_rounds = max_rounds
    emit_signal("round_count_changed", group_index, current_rounds)
