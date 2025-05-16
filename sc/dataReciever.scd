s.scope;
( // initialized control bus
Ndef(\ctrl, {0.0 ! 15})
)

(// initialize oscdef
OSCdef(\recieveLetterCounts, {
	|msg, time, addr, port|
	Ndef(\ctrl, { msg[1..] });
}, '/fromScrapy')
)

(// debug
Ndef(\ctrl).numChannels;
)

(// preset
Ndef(\get, {DC.ar(Ndef(\ctrl).kr[0])}).play
)

// -------------------- ab hier für synthDef und Patterns


( // initialize data Array
~data = Array.newClear(15);
)
(// initialize oscdef

OSCdef(\recieveLetterCounts, {
	|msg, time, addr, port|

	msg[1..].do{
		|item, i|
		~data[i] = item;
	};
	~data.postln;
}, '/fromScrapy')
)