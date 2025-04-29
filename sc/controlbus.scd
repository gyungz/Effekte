s.scope;
// initialize control Bus Array and osc function
(
~numControlChannels = 15;
f = { |msg, time, addr|
    if(msg[0] == '/fromScrapy') {
        "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};
thisProcess.addOSCRecvFunc(f);
~control = Array.new(~numControlChannels);
)
// free all Control Busses and reinitialize control Bus Array
(
~numControlChannels.do{|i| ~control[i].free}
~control = Array.new(~numControlChannels);
)

// get control data from osc python
(
OSCdef(\soundTrigger, { |msg|
    var letter = msg[1], count = msg[2];
    ("Buchstabe: " ++ letter ++ " | Anzahl: " ++ count).postln;
	~control.add(Bus.control(s, 1).set(count));
}, '/fromScrapy');
)
(
OSCdef(\debugAll, { |msg, time, addr, port|
    "DEBUG OSC >>>".postln;
    msg.postln;
}, '/fromScrapy');
)
// set default wert, bei leeren control bus channels: grade default = 200
(
15.do{|i|
	if (~control[i] == nil,
		{~control.add(Bus.control(s, 1).set(200))}
	);
}
)


~control[0].get()
~control[1].get()
~control[6].get()

3.do{|i| ~control[i].free}
15.do{|i| ~control.add(Bus.control(s, 1).set(i % 4))}
15.do{|i| ~control[i].get()}
15.do{|i| ~control[i].set(0)}
