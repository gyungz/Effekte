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
