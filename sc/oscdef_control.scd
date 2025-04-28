s.scope
s.plotTree;
s.sendMsg(\n_free, 1001)
a = Bus.control(s, 1).set(0.5);
b = Bus.control(s, 1).set(1)
Bus.control(s, 1).set(0.5)
a.free(true)
a.set(0, 1)
a.get


(

f = { |msg, time, addr|
    if(msg[0] == '/fromScrapy') {
        "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};
// bei nächster Ausführung sollen die control channels von 0 bis 15 wieder gesetzt werden
var startChannel = 0;
thisProcess.addOSCRecvFunc(f);
OSCdef(\soundTrigger, { |msg|
    var letter = msg[1], count = msg[2];
    ("Buchstabe: " ++ letter ++ " | Anzahl: " ++ count).postln;
	Bus.control(s, 1).set(count);
}, '/fromScrapy');
)
Out.kr(0, DC.kr(500.0))

Bus.new('control', 0, 15, s)
(SynthDef(\bus, {|value = 0.5|
	var sig;
	sig = DC.kr(value);
	Out.kr(0, sig);
}
).add;
)
(SynthDef(\sinwave, {|freq = 10|
	var sig;
	sig = SinOsc.kr(freq);
	Out.kr(0, sig);
}
).add;
)
x = Synth(\bus)
x.set(\value, 20)
x.free
(
{var sig;
	sig = In.kr(0, 1);
	sig.poll();
}.play;
)
y = Synth(\sinwave)
y.set(\freq, 1000)
