(
OSCFunc.trace(true);  // Zeigt empfangene OSC-Nachrichten im Postfenster

OSCdef(\soundTrigger, { |msg|
    var letter = msg[1], count = msg[2];
    var snd;
    ("Buchstabe: " ++ letter ++ " | Anzahl: " ++ count).postln;
	snd = NodeProxy().fadeTime_(4).play;
    // Beispiel: moduliere die Frequenz basierend auf die Häufigkeit einer Buchstabe
	snd.source_({SinOsc.ar(count)});
}, '/fromScrapy');
)
s.scope
s.plotTree

(
SynthDef(\text, {
	var snd;
	snd = SinOsc.ar(\freq.ar(200) + (\modfreq.ar(50) * \modamt.ar(1000)));
	Out.ar(0, Splay.ar(snd * \amp.ar(0.02)));
}).add;
)
x = NodeProxy().fadeTime_(4).play
x.source_({SinOsc.ar(50)});

x.free;

'letter'.ascii.postln;
