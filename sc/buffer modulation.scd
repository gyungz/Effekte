

~buf = Buffer.read(s, "/Users/davidtanner/Music/EffekteJazz/ComputerMster.wav");
~buf2 = Buffer.read(s, "/Users/davidtanner/Music/EffekteJazz/HarmonischeFläche.wav");
~vocBuf = Buffer.read(s, "/Users/davidtanner/Music/EffekteJazz/VoiceSamples/IsThatAllThereIs?.wav");

(
{
	// stereo rate modulation
	// rate jumps (LFPulse) cause change of direction

	var rateMod = SinOsc.ar(5 * [1, 1.1]).range(1, Saw.ar(9) + 1)
                  * LFPulse.ar(3).range(-1, 1);
	PlayBuf.ar(
		numChannels: 1,
		bufnum: ~buf,
		rate: rateMod * BufRateScale.ir(~buf),
		loop: 1
	) * 0.5
}.play;
)

(
{
	var baseRate = SampleRate.ir * BufRateScale.ir(~buf2);
	var mod = LFPulse.ar(0.5 / 4).range(0, 1) * [1, 1.1];
	var sweep = Sweep.ar(rate: baseRate * mod);
	var jump = LFPulse.ar(2).range(~buf2.numFrames * (-1), ~buf2.numFrames);
	var sig = BufRd.ar(
		numChannels: 1,
		bufnum: ~buf2,
		phase: sweep + jump,
		loop: 1
	) * 0.5;
	LPF.ar(sig, 5000);
}.play;
)

//coole Soundfläche
(
{
	var baseRate = SampleRate.ir * BufRateScale.ir(~buf);
	var mod = LFPulse.ar(0.5 / 5).range(1, 1.2) * [1, 1.01];
	var sweep = Sweep.ar(rate: baseRate * mod);
	var jump = LFPulse.ar(2).range(~buf2.numFrames * (-0.9), ~buf2.numFrames);
	var sig = BufRd.ar(
		numChannels: 1,
		bufnum: ~buf2,
		phase: sweep + jump,
		loop: 1
	) * 0.5;
	LPF.ar(sig, 5000);
}.play;
)

(

SynthDef(\rewrite_odub, { |out, impulseRate = 5, impulseWidth = 0.1,
		readRate = 1, readLRdiff = 1, writeRate = 1, writeDev = 0,
		writeModFreq = 0, odubMix = 0.5, len = 1, cutoff = 5000,
		amp = 0.3|
	var read_1, read_2, readRates, readPhase, write,
		writePhase, writeOsc, odub;
	var inSig = LFPulse.ar(impulseRate, width: impulseWidth);
	var frames = BufFrames.ir(~vocBuf);
	var rangeF = 1 + (writeDev / 100);

	writeOsc = LFDNoise3.ar(writeModFreq).range(1 / rangeF, rangeF);
	writePhase = Phasor.ar(0, writeRate * writeOsc, 0, frames * len);
	read_1 = BufRd.ar(1, ~vocBuf, writePhase);
	odub = inSig * (1 - odubMix) + (read_1 * odubMix);
	write = BufWr.ar(odub, ~vocBuf, writePhase);
	readRates = readRate * [1, readLRdiff / 100 + 1];
	readPhase = Phasor.ar(0, readRates, 0, frames * len);
	read_2 = BufRd.ar(1, ~vocBuf, readPhase);
	Out.ar(out, Limiter.ar(LeakDC.ar(LPF.ar(read_2, cutoff)), amp));
}, metadata: (
	specs: (
		impulseRate: [1, 20, \lin, 0, 5],
		impulseWidth: [0.01, 1, \lin, 0, 0.1],
		readRate: [0.2, 2, \lin, 0, 1],
		readLRdiff: [0.2, 2, \lin, 0, 1],
		writeRate: [0.2, 2, \lin, 0, 1],
		writeDev: [0, 5, \lin, 0, 0],
		writeModFreq: [0, 5, 5, 0, 0],
		odubMix: [0, 1, \lin, 0, 0.5],
		len: [0.01, 1, 5, 0, 1],
		cutoff: [50, 16000, \exp, 0, 5000],
		amp: [0, 1, \db, 0, 1]
	)
)
).add;
)

(
SynthDef(\rewrite_odub, { |out, impulseRate = 5, impulseWidth = 0.1,
		readRate = 1, readLRdiff = 1, writeRate = 1, writeDev = 0,
		writeModFreq = 0, odubMix = 0.5, len = 1, cutoff = 5000,
		amp = 0.3|
	var read_1, read_2, readRates, readPhase, write,
		writePhase, writeOsc, odub;
	var inSig = LFPulse.ar(impulseRate, width: impulseWidth);
	var frames = BufFrames.ir(~buf2);
	var rangeF = 1 + (writeDev / 100);

	writeOsc = LFDNoise3.ar(writeModFreq).range(1 / rangeF, rangeF);
	writePhase = Phasor.ar(0, writeRate * writeOsc, 0, frames * len);
	read_1 = BufRd.ar(1, ~buf2, writePhase);
	odub = inSig * (1 - odubMix) + (read_1 * odubMix);
	write = BufWr.ar(odub, ~buf2, writePhase);
	readRates = readRate * [1, readLRdiff / 100 + 1];
	readPhase = Phasor.ar(0, readRates, 0, frames * len);
	read_2 = BufRd.ar(1, ~buf2, readPhase);
	Out.ar(out, Limiter.ar(LeakDC.ar(LPF.ar(read_2, cutoff)), amp));
}, metadata: (
	specs: (
		impulseRate: [1, 20, \lin, 0, 5],
		impulseWidth: [0.01, 1, \lin, 0, 0.1],
		readRate: [0.2, 2, \lin, 0, 1],
		readLRdiff: [0.2, 2, \lin, 0, 1],
		writeRate: [0.2, 2, \lin, 0, 1],
		writeDev: [0, 5, \lin, 0, 0],
		writeModFreq: [0, 5, 5, 0, 0],
		odubMix: [0, 1, \lin, 0, 0.5],
		len: [0.01, 1, 5, 0, 1],
		cutoff: [50, 16000, \exp, 0, 5000],
		amp: [0, 1, \db, 0, 1]
	)
)
).add;
)

~x = Synth(\rewrite_odub);
~x.play




(
SynthDef(\rewrite_odub, { |out, impulseRate = 0.5, impulseWidth = 0.1,
		readRate = 1, readLRdiff = 1, writeRate = 0.5, writeDev = 0,
		writeModFreq = 0, odubMix = 0.5, len = 1, cutoff = 5000,
		amp = 0.3|
	var read_1, read_2, readRates, readPhase, write,
		writePhase, writeOsc, odub;
	var inSig = LFPulse.ar(impulseRate, width: impulseWidth);
	var frames = BufFrames.ir(~buf2);
	var rangeF = 1 + (writeDev / 100);

	writeOsc = LFDNoise3.ar(writeModFreq).range(1 / rangeF, rangeF);
	writePhase = Phasor.ar(0, writeRate * writeOsc, 0, frames * len);
	read_1 = BufRd.ar(1, ~buf2, writePhase);
	odub = inSig * (1 - odubMix) + (read_1 * odubMix);
	write = BufWr.ar(odub, ~buf2, writePhase);
	readRates = readRate * [1, readLRdiff / 100 + 1];
	readPhase = Phasor.ar(0, readRates, 0, frames * len);
	read_2 = BufRd.ar(1, ~buf2, readPhase);
	//Out.ar(out, Limiter.ar(LeakDC.ar(LPF.ar(read_2, cutoff)), amp));
}, metadata: (
	specs: (
		impulseRate: [1, 20, \lin, 0, 5],
		impulseWidth: [0.01, 1, \lin, 0, 0.1],
		readRate: [0.2, 2, \lin, 0, 1],
		readLRdiff: [0.2, 2, \lin, 0, 1],
		writeRate: [0.2, 2, \lin, 0, 1],
		writeDev: [0, 5, \lin, 0, 0],
		writeModFreq: [0, 5, 5, 0, 0],
		odubMix: [0, 1, \lin, 0, 0.5],
		len: [0.01, 1, 5, 0, 1],
		cutoff: [50, 16000, \exp, 0, 5000],
		amp: [0, 1, \db, 0, 1]
	)
)
).add;
)

SynthDescLib.global[\rewrite_odub].makeGui;

