
c = []
(
// OSCFunc.trace(true);  // Zeigt empfangene OSC-Nachrichten im Postfenster
f = { |msg, time, addr|
    if(msg[0] == '/fromScrapy') {
        "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};

thisProcess.addOSCRecvFunc(f);
OSCdef(\soundTrigger, { |msg|
    var letter = msg[1], count = msg[2];
    // ("Buchstabe: " ++ letter ++ " | Anzahl: " ++ count).postln;
	c.add(msg);
	// c.postln;
	// Ndef(\textToSound).xset(\freq, count, \spread, 1, \amp, 0.7)
}, '/fromScrapy');
)
c.[0].postln;
OSCdef.freeAll
s.scope
s.plotTree
(Ndef(\textToSound, {
	|freq=70, spread=1, amp=0.5|
	var snd, env;
	env = Env.perc(0.01, 1, 1, -4).ar();
	snd = [SinOsc.ar(freq), LFTri.ar(freq), SinOsc.ar(freq + (LFTri.ar(freq % 5) * 30))];
	snd = MoogFF.ar(snd, 500, 1.2);
	snd = Splay.ar(snd * amp, spread);
}).play)


Ndef(\textToSound).set()
Ndef(\textToSound).xset(\freq, rrand(20, 2080), \spread, 1, \amp, 0.7)
Ndef(\textToSound).fadeTime_(1)



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
