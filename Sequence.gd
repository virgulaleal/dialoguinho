extends Resource
class_name Sequence


signal finished


@export var eventos: Array[Evento]


func size() -> int:
	
	return eventos.size()
