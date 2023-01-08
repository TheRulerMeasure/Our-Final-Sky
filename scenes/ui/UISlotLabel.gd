extends MarginContainer


func _ready():
    var _c := GameGlobal.connect("round_reload_time", self, "_on_reload_time")
    _c = GameGlobal.connect("round_count_changed", self, "_on_round_count_changed")
    _c = GameGlobal.connect("slot_set_active", self, "_on_slot_set_active")


func slot_label(index: int) -> Label:
    return $VBoxContainer.get_child(index).get_node("Label") as Label


func slot_ref_rect(index: int) -> ReferenceRect:
    return $VBoxContainer.get_child(index).get_node("ReferenceRect") as ReferenceRect


func _on_slot_set_active(index: int, active: bool) -> void:
    var ref_rect := slot_ref_rect(index)
    ref_rect.visible = active


func _on_reload_time(index: int, seconds: float) -> void:
    var sec := max(4.5 - seconds, 0.0)/4.5
    var label := slot_label(index)
    label.modulate = Color(1.0, sec, sec)
    label.text = "%.1f" %seconds


func _on_round_count_changed(index: int, rounds: int) -> void:
    if rounds < 10:
        slot_label(index).modulate = Color.darkgreen
    else:
        slot_label(index).modulate = Color.green
    slot_label(index).text = "Slot " + str(index+1) + ": " + str(rounds)
