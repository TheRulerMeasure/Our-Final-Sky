extends MarginContainer


func _ready() -> void:
    var _c := GameGlobal.connect("plane_count_changed", self, "change_air_targets_count")
    _c = GameGlobal.connect("plane_destroyed_count_changed", self, "_on_plane_destroyed_count_changed")


func change_air_targets_count(amount: int) -> void:
    $HBoxContainer/AirTargets/Label.text = "Air Targets: " + str(amount)


func change_destroyed_targets_count(mob_count: int, destroyed_count: int) -> void:
    $HBoxContainer/Destroyed/Label.text = (
        "Destroyed Targets: " +
        str(destroyed_count) +
        "/" +
        str(mob_count)
    )


func _on_plane_destroyed_count_changed(count: int, mob_count: int) -> void:
    change_destroyed_targets_count(mob_count, count)
