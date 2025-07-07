extends Node

var timer_running = false
var timer_paused = false
var timer_start_value = 3 #15.0*60
var time_elapsed = 0.0

enum STATE {RUNNING, NOT_STARTED, DONE, PAUSED}
var timer_state = STATE.NOT_STARTED

''' TODO: Try with timer!!!
func _process(_delta: float) -> void:
	var time_left = $Timer.time_left
	$Label.text = format_seconds_to_mmss(int(ceil(time_left)))
'''

var start_timer_button : Button
var resume_timer_button : Button
var pause_timer_button : Button
var reset_timer_button : Button

func _ready() -> void:
	start_timer_button = $CanvasLayer/HBoxContainer/StartTimer
	resume_timer_button = $CanvasLayer/HBoxContainer/ResumeTimer
	pause_timer_button = $CanvasLayer/HBoxContainer/PauseTimer
	reset_timer_button = $CanvasLayer/HBoxContainer/ResetTimer
	#$Timer.start(55)
	update_buttons()
	
	
func _process(delta: float) -> void:
	if $Timer.time_left == 0:
		$CanvasLayer/HBoxContainer2/Time.text = format_seconds_to_mmss(timer_start_value)
	else:
		$CanvasLayer/HBoxContainer2/Time.text = format_seconds_to_mmss($Timer.time_left)

func format_seconds_to_mmss(total_seconds : float) -> String:
	var total_seconds_int = int(total_seconds)
	var minutes = total_seconds_int / 60
	var seconds = total_seconds_int % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_start_timer_pressed() -> void:
	timer_state = STATE.RUNNING
	$Timer.start(timer_start_value)
	
	## TODO:
	timer_running = true
	timer_paused = false
	update_buttons()


func _on_pause_timer_pressed() -> void:
	timer_state = STATE.PAUSED
	timer_running = false
	timer_paused = true
	update_buttons()
	


func _on_reset_timer_pressed() -> void:
	timer_state = STATE.NOT_STARTED
	time_elapsed = timer_start_value
	timer_running = false
	timer_paused = false
	update_buttons()
	
func _on_resume_timer_pressed() -> void:
	timer_state = STATE.RUNNING
	timer_paused = false
	timer_running = true
	update_buttons()


func _on_increase_timer_pressed() -> void:
	timer_start_value += 60


func _on_decrease_timer_pressed() -> void:
	timer_start_value -= 60
	if timer_start_value <= 0:
		timer_start_value = 0



func update_buttons() -> void:
	get_tree().call_group("Buttons","set","visible",false)
	if timer_running:
		if timer_paused:
			resume_timer_button.visible = true
			reset_timer_button.visible = true
		else:
			pause_timer_button.visible = true
	else:
		if timer_paused:
			reset_timer_button.visible = true
		else:
			start_timer_button.visible = true


func _on_timer_timeout() -> void:
	timer_state = STATE.DONE
	print("Timer over")
