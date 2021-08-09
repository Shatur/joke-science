class_name CardParser
extends Object


var cards: Array


func open(filename: String) -> JSONParseResult:
	var file := File.new()
	var open_result: int = file.open(filename, File.READ)
	if open_result != OK:
		var result := JSONParseResult.new()
		result.error = ERR_FILE_CANT_OPEN
		result.error_line = -1
		result.error_string = "Unable to open file " + filename
		return result

	var parse_result: JSONParseResult = JSON.parse(file.get_as_text())
	if parse_result.error != OK:
		return parse_result

	if typeof(parse_result.result) != TYPE_ARRAY:
		parse_result.error = ERR_INVALID_DATA
		parse_result.error_string = "Expected array"
		parse_result.error_line = 0
		return parse_result

	cards = parse_result.result

	return parse_result
