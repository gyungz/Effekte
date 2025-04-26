(//init+Metronom. nur einmal ausführen
~postinfo = { t.beats.postln; 1;};
t = TempoClock.new(50/60).permanent_(true);
t.sched(0, {~postinfo.()});
q = 4; // z/q Takt d.h. 4/4
z = 4;
Tdef.defaultQuant = q;
)

b = Buffer.read(s, "/Users/davidtanner/Music/EffekteJazz/ComputerMster.wav");
//Load sample into buffer



(
Ndef(\pitch, { |spot = 100, bufnum = 0|
        var sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: spot, doneAction: Done.freeSelf);
        var pitch = Pitch.kr(sig, maxFreq: 13000, execFreq: 100);
        var freq = pitch[0];
        var sig2 = BRF.ar(sig, freq, 0.1);
        var pitch2 = Pitch.kr(sig2, maxFreq: 13000, execFreq: 100);
        var freq2 = pitch2[0];
        var sig3 = BRF.ar(sig2, freq2, 0.1);
        var pitch3 = Pitch.kr(sig3, maxFreq: 13000, execFreq: 100);
        var freq3 = pitch3[0];
        [freq, freq2, freq3].poll;
        BRF.ar(sig3, freq3, 0.1) * MouseX.kr(0, 1);
	sig3 = sig3 - sig;
});
)
Ndef(\pitch).play

(
Ndef(\Playbackspeed_, {| out = 0, bufnum = 0, spot = 100,  speed = 1, length = 3000|
	var env, envGen, sig;
	env = Env([1, 1], [length]);
	envGen = EnvGen.ar(env, doneAction: Done.freeSelf);
	sig = PlayBuf.ar(2, bufnum, LFNoise0.ar(10, 3), startPos: spot, doneAction: Done.freeSelf) * envGen;
	Out.ar(out,sig);
}).add;
)


(
Ndef(\ringModFB, { |spot = 100, bufnum = 0|
	var modCtrl = MouseY.kr(0, 220); // modulationstiefe
	var ctrl = MouseX.kr(0, 1);
	var buf = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: spot, doneAction: Done.freeSelf);
	var modRegular = SinOsc.ar(220) * (1.0 - ctrl);
    var modFeedback = Ndef(\fb).ar * ctrl;

    var mod = (modRegular + modFeedback) * modCtrl;
    var sig = buf * SinOsc.ar(440 + mod) ;
        sig;
});
)
Ndef(\ringModFB).play


(
Ndef(\buffFeedback, { |spot = 100, bufnum = 0|
	var sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: spot, doneAction: Done.freeSelf);
 	var delayTime = MouseX.kr(0, 0.05);
 	var fb2 = Ndef(\fb2).ar;
	var lfo = LFNoise2.ar(1).range(1, 1.01);
	//sig = sig + LFNoise2(0.1);
 	sig = sig + (DelayC.ar(fb2, 0.3, delayTime * lfo) * -0.99);

 	sig;
 });
 )
Ndef(\buffFeedback).play

Ndef(\modBuf, {|speed = 1, length = 1|
	var env, envGen, sig;

	env = Env([1, 1], [length]);
	envGen = EnvGen.ar(env, doneAction: Done.freeSelf);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: spot, doneAction: Done.freeSelf) * envGen;
	Out.ar(out,sig);
})

(
SynthDef(\help_PlayBuf, {| out = 0, bufnum = 0, spot = 100,  speed = 1, length = 1|
	var env, envGen, sig;
	env = Env([1, 1], [length]);
	envGen = EnvGen.ar(env, doneAction: Done.freeSelf);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), startPos: spot, doneAction: Done.freeSelf) * envGen;
	Out.ar(out,sig);
}).add;
)

Synth(\help_PlayBuf, [\out, [0, 1], \bufnum, b, \spot, 300, \length, 1]);


b = Buffer.read(s, "/Users/davidtanner/Music/EffekteJazz/ComputerMster.wav");

SynthDef(\help_PlayBuf, {| out = 2, bufnum = 0, spot = 0,  speed = 1|
    Out.ar(out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), doneAction: Done.freeSelf)
    )
}).play(s, [\out, 0, \bufnum, b]);

(
SynthDef(\roseAmpMod, { | n = 5, d = 1, t = 100, c = 0.2, amp = 0.7 |

	var x, y, env, envGen, envMod, envGenMod, modx, mody, envOv, envGenOv;
	env = Env([0, 1, 0, 1, 0, 0.9, 1], [2, 0.2, 1, 0.2, 5, 15]);
	envGen = EnvGen.ar(env, doneAction: Done.freeSelf );
	envMod = Env([0, 0, 0.5, 0.01], [4, 12, 15]);
	envGenMod = EnvGen.ar(envMod);
	envOv = Env([1, 1, 2], [30, 30]);
	envGenOv = EnvGen.ar(envOv, doneAction: Done.freeSelf );
	modx = SinOsc.ar(220, mul: 20) * envGenMod;
	mody = SinOsc.ar(219, 0.25, 22) * envGenMod;
	x = (SinOsc.ar(((n/d) + modx) * t, pi/2) + c) * SinOsc.ar(t, pi/2);
	y = (SinOsc.ar(((n/d) + mody) * t, pi/2) + c) * SinOsc.ar(t, 0);

	Out.ar(0, [x, y] * amp * SinOsc.ar(0.2, 0.0, 0.1, 0.9) * envGen /* * envGenOv*/ );
}).add
);

(
var midi, dur;
midi = Pseq([1, 2, 5, 3, 2, 8, 9, 10, 3, 14], 1).asStream;
dur = Pseq([1, 0.5, 0.5, 1, 0.5, 0.25], 1).asStream;


/*
Sample ausschnitte auf Beat quantisieren :)
*/

r = Task({
    var delta;
    while {
        delta = dur.next;
        delta.notNil
    } {
		//Synth(\roseAmpMod, [n: midi.next, d: delta]);
        Synth(\help_PlayBuf, [out: [0, 1], bufnum: b, spot: midi.next * 44000, length: delta]);
        delta+2.yield;
    }
}).play(quant: TempoClock.default.beats + 1.0);
)
