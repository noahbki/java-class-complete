
module.exports = JavaClassComplete =

	activate: ->
		console.log "Java Class Complete Activated!"

	consumeClasscomplete: (addTemplate) ->
		templateInfo =
			"name": "java"
			"complete":
				require "./java-complete.coffee"
			"fileTypes":
				["java"]
		addTemplate(templateInfo)
