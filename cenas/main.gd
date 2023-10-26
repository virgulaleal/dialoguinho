extends Control


const FREQUENCIA: float = 0.075

const PAUSAS: Dictionary = {
	" ": 0.25,
	"\n": 1.25,
	".": 2.0,
	",": 1.5,
	"-": 2.25,
	"!": 1.75
}


enum dialogo_states {
	SETUP,
	IDLE,
	TYPING
}

var dialogo_state: dialogo_states = dialogo_states.SETUP

var sequence: Sequence = preload("res://sequences/TesteSequence.tres")
var sequence_index: int = 0


@onready var frame_l: TextureRect = %FrameL
@onready var frame_r: TextureRect = %FrameR
@onready var legenda_label: Label = %LegendaLabel


func _ready() -> void:
	
	reset_dialogo()
	dialogo_state = dialogo_states.IDLE


func _input(event):
	
	if event.is_action_pressed("action"):
		
		advance_dialogo()


func reset_dialogo() -> void:
	
	frame_l.modulate.a = 0.0
	frame_r.modulate.a = 0.0
	frame_l.texture = null
	frame_r.texture = null
	legenda_label.modulate.a = 0.0
	legenda_label.visible_ratio = 0.0
	legenda_label.text = ""


func resfriar_molduras() -> void:
	
	frame_l.modulate.a = 0.33
	frame_r.modulate.a = 0.33


func advance_dialogo() -> void:
	
	if dialogo_state == dialogo_states.TYPING:
		
		if legenda_label.visible_characters <= 1:
			return
		
		legenda_label.visible_characters = legenda_label.text.length()
		
		return
	
	if dialogo_state != dialogo_states.IDLE:
		return
	
	if sequence_index >= sequence.size() - 1:
		reset_dialogo()
		sequence.finished.emit()
		sequence_index = 0
		return
	
	var evento: Evento = sequence.eventos[sequence_index]
	
	if evento is FalaEvento:
		
		dialogo_state = dialogo_states.TYPING
		
		resfriar_molduras()
		
		if evento.lado == evento.lados.ESQUERDA:
			frame_l.texture = evento.get_frame_texture()
			frame_l.modulate.a = 0.9
		elif evento.lado == evento.lados.DIREITA:
			frame_r.texture = evento.get_frame_texture()
			frame_r.modulate.a = 0.9
			frame_r.flip_h = !evento.force_flip
		
		legenda_label.modulate = evento.get_texto_color()
		
		await typewrite(evento.texto, FREQUENCIA)
		
		sequence_index += 1
		
		dialogo_state = dialogo_states.IDLE


func typewrite(text: String, frequencia: float) -> void:
	
	legenda_label.visible_characters = 0
	legenda_label.modulate.a = 1.0
	legenda_label.text = text
	
	while legenda_label.visible_characters < legenda_label.text.length():
		
		var wait_time: float = frequencia * randf_range(0.85, 1.05)
		
		legenda_label.visible_characters += 1
		
		var chara: = legenda_label.text[legenda_label.visible_characters - 1]
		var player: AudioStreamPlayer = $VozPlayer
		
		if chara in PAUSAS.keys():
			wait_time += frequencia * PAUSAS[chara]
		
		player.pitch_scale = randf_range(0.9, 1.1)
		player.play()
		
		if legenda_label.visible_characters == legenda_label.text.length():
			await create_tween().tween_interval(frequencia * 0.25).finished
		
		await create_tween().tween_interval(wait_time).finished
