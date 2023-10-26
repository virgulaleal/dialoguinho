@tool
extends Evento
class_name FalaEvento


enum lados{
	ESQUERDA,
	DIREITA,
	NENHUM
}


@export var personagem: Personagem

@export_multiline var texto: String = "" : set = _set_texto

@export var lado: lados = lados.ESQUERDA

@export_group("Overrides")

@export var nome_override: String = ""
@export var override_nome_color: bool = false
@export var nome_color_override: Color = Color("f4f4f4")
@export var override_texto_color: bool = false
@export var texto_color_override: Color = Color("ffffff")
@export var force_flip: bool = false

@export var frame_texture_override: Texture


func get_nome() -> String:
	
	if nome_override != "" or not personagem:
		return nome_override
	
	return personagem.nome


func get_nome_color() -> Color:
	
	if override_nome_color or not personagem:
		return nome_color_override
	
	return personagem.nome_color


func get_texto_color() -> Color:
	
	if override_texto_color or not personagem:
		return texto_color_override
	
	return personagem.texto_color


func get_frame_texture() -> Texture:
	
	if frame_texture_override or not personagem:
		return frame_texture_override
	
	return personagem.frame_texture


func _set_texto(_texto: String) -> void:
	
	texto = _texto
	
	if not Engine.is_editor_hint():
		return
	
	resource_name = texto
