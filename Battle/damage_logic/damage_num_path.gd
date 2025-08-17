extends PathFollow2D



var delta_offset = 0
var id =0
var link = self
var is_child = false
var text_label
# Called when the node enters the scene tree for the first time.
func _ready():
    if is_child:
        link.new_damage_num.connect(Callable(self, "_move_down"))
    text_label = get_node("RichTextLabel")
    #get_node(".").animate_num.connect(Callable(self, "_on_character_animate_num"))
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if progress_ratio < 0.90:
        progress_ratio += delta * 3
    delta_offset += delta
    if delta_offset > 1 and delta_offset < 1.1:
        text_label.text = ""
        if is_child:
            self.queue_free()







func _move_down(value):
    if id != value:
        text_label.position.y += 18


func _on_character_animate_num(val):
    #progress_ratio = 0
    #delta_offset = 0
    #print("reset!")
    pass
