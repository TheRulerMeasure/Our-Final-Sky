extends Node

signal display_label(instance_id, text, delay_percent, delay_before_remove)
signal done_display

export(String, MULTILINE) var text
export(float, 0.07, 10, 0.02) var delay_before_remove: float = 5.0
export(float, 0.07, 10, 0.02) var delay_percent: float = 0.5


func _ready() -> void:
    var _c := connect("display_label", GameGlobal, "_on_LowerLeftLabel_display_label")
    _c = GameGlobal.connect("label_done_display", self, "_on_GG_done_display")


func display_label() -> void:
    emit_signal("display_label", get_instance_id(), text, delay_percent, delay_before_remove)


func _on_GG_done_display(rid: int) -> void:
    if get_instance_id() == rid:
        emit_signal("done_display")
