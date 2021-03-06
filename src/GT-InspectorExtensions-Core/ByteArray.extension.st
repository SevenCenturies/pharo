Extension { #name : #ByteArray }

{ #category : #'*GT-InspectorExtensions-Core' }
ByteArray >> gtInspectorBytesIn: composite [
	<gtInspectorPresentationOrder: 30>
	^ composite table
		title: 'Bytes';
		display: [ 
			(self size < 2048 or: [ self confirm: 'Looking at more than 2048 bytes might be slow. Continue ?' ])
				ifTrue: [ {
					'hex string' -> (String streamContents: [ :out | 
						self printHexOn: out ]).
					'hex lines' -> (String streamContents: [ :out |
						self withIndexDo: [ :each :index |
							index = 1 ifFalse: [ 
								index - 1 \\ 8 = 0 ifTrue: [ out cr ] ifFalse: [ out space ] ].
								each printHexByteOn: out ] ]).
					'latin1' -> ([ ZnCharacterEncoder latin1 decodeBytes: self ]
											on: ZnCharacterEncodingError do: [ :exception | exception ]).
					'utf8' -> ([ ZnUTF8Encoder new decodeBytes: self ] 
											on: ZnCharacterEncodingError do: [ :exception | exception ]).
					'integer' -> self asInteger.
					'integer reversed' -> self reversed asInteger } ]
				ifFalse: [ #() ] ];
		column: 'Key' evaluated: #key;
		column: 'Value' evaluated: #value;
		send: #value
]

{ #category : #'*GT-InspectorExtensions-Core' }
ByteArray >> gtInspectorHexDumpIn: composite [
	<gtInspectorPresentationOrder: 40>
	composite text
			title: 'Hex Dump';
			format: #asText;
			when: [ self isCompiledMethod not ];
			display: [ | maxBytes displayStream displayString |
				maxBytes := 10000.
				displayStream := (String new: maxBytes * 5) writeStream.
				self hexDumpOn: displayStream max: maxBytes.
				displayString := displayStream contents asText.
				displayString addAttribute: (TextFontReference
						toFont: (LogicalFont 
							familyName: 'Source Code Pro' 
							pointSize: StandardFonts defaultFont pointSize)).
				displayString asText ]
]
