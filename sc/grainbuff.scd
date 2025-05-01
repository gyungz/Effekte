s.scope
s.plotTree;
b = Buffer.readChannel(s, "/Users/jiyeonglee/Desktop/EFFEKTE/ComputerMster.wav", channels: [0]);
b.numChannels
b.numFrames
(
  SynthDef(\playSample, {
    var outBus = 0;
    var susLevel = 0.6;
    var releaseTime = LFNoise0.kr(40, 2, 0.2);
    var startPos = LFNoise2.kr(500, 1, 0.0) * ~sample.numFrames;
    var gate = Line.kr(1, 0, 0.005);
    var amp = Linen.kr(gate, 0.01, susLevel, releaseTime, 2);
    var playBuf = PlayBuf.ar(2, ~sample, 1, 1, startPos: startPos, doneAction: 2);
    Out.ar(outBus, playBuf * amp);
    }).add
)
(
SynthDef(\basicGrain, {
	var snd, sndBuf;
	snd = GrainBuf.ar(1, Impulse.ar(10), 0.5, b);
	Out.ar(0, snd);
}).add;
)


(
SynthDef(\modulatedGrain, {
	var snd, filePos, env, envTrig, decTime;
	decTime = \decTime.ar(1);
	envTrig = Impulse.ar(\gateTime.ar(100));
	env = Env.adsr(0.01, decTime, 0.4, 0.1).ar(gate: envTrig, doneAction: 0);
	// filePos = (XLine.ar(1, b.numFrames, 10) * Latch.ar(SinOsc.ar(1), LFNoise0.ar(100))).clip(0, 1);
	// filePos = (XLine.kr(0.5, b.numFrames, 1) * Latch.ar(SinOsc.ar(\posModTime.ar(10)), LFNoise0.ar(100))).range(0, 1);
	filePos = (XLine.kr(1, 2, decTime) -1);
	snd = GrainBuf.ar(1, Impulse.ar(10), 0.5, b, pos:filePos);
	snd = Splay.ar((snd * 2).fold(-1, 1) * env * 2);
	Out.ar(0, snd.clip(-1, 1));
}).add;
)

x = Synth(\modulatedGrain, [\decTime, 0.1]);
x.set(\decTime, 1, \gateTime, 7, \posModTime, 40)
x.free;
