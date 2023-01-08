extends MarginContainer

signal done_display(node_rid)

var label_node_rid: int


func _ready() -> void:
    var _c := $Tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
    _c = $RemoveTextTimer.connect("timeout", self, "_on_RemoveTextTimer_timeout")
    _c = GameGlobal.connect("display_lower_left_label", self, "_on_display_label")
    _c = connect("done_display", GameGlobal, "_on_UILabel_done_display")


func _on_display_label(
    node_rid: int,
    text: String,
    delay_percent: float,
    delay_before_remove: float
) -> void:
    label_node_rid = node_rid
    if not $RemoveTextTimer.is_stopped():
        $RemoveTextTimer.stop()
    $RemoveTextTimer.wait_time = delay_before_remove

    $Label.percent_visible = 0.0
    $Label.text = text

    if $Tween.is_active():
        $Tween.remove_all()

    $Tween.interpolate_property(
        $Label,
        "percent_visible",
        0.0,
        1.0,
        delay_percent
    )
    $Tween.start()


func _on_Tween_all_completed() -> void:
    $RemoveTextTimer.start()


func _on_RemoveTextTimer_timeout() -> void:
    $Label.text = ""
    emit_signal("done_display", label_node_rid)
