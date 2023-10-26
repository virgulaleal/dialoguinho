@tool
extends Evento
class_name TexturaEvento


const modo_strings: Dictionary = {
	modos.ENTRA: "Entra",
	modos.MOVE: "Move",
	modos.SAI: "Sai"
}


enum modos {
	ENTRA,
	MOVE,
	SAI
}


@export var etiqueta: String = "" : set = _set_etiqueta
@export var textura: Texture : set = _set_textura
@export var modo: modos = modos.ENTRA : set = _set_modo
@export var position: Vector2 = Vector2.ZERO
@export var scale: Vector2 = Vector2.ONE
@export var duration: float = 0.0
@export var transition: Tween.TransitionType = Tween.TRANS_QUART
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var filter: CanvasItem.TextureFilter = CanvasItem.TextureFilter.TEXTURE_FILTER_NEAREST
@export var segura: bool = false


func get_filename() -> String:
	
	if not textura:
		return ""
	
	return textura.resource_path.get_file()


func update_resource_name() -> void:
	
	var format: Array = [
		modo_strings[modo],
		get_filename()
	]
	
	resource_name = "[%s %s]" % format
	
	if etiqueta:
		resource_name += " (%s)" % etiqueta


func _set_etiqueta(_etiqueta: String) -> void:
	
	etiqueta = _etiqueta
	
	if Engine.is_editor_hint():
		update_resource_name()


func _set_textura(_textura: Texture) -> void:
	
	textura = _textura
	
	if Engine.is_editor_hint():
		update_resource_name()


func _set_modo(_modo: modos) -> void:
	
	modo = _modo
	
	if Engine.is_editor_hint():
		update_resource_name()
