# formalMethods-TrafficLightSystem
Seng 480A Formal Methods final project
Team: 
Cole McGinn,
Gaurav Thakur,
Muhammad Zubair,

##Part	1:	Simple	TCS
The	TCS	shall	control	a	four-way	intersection.	The	lights	are	automatically	toggled	based	on	a	
predefined	interval.

Prove	that	your	specification	meets	the	following	properties:

1. Either	NS	direction	or	EW direction	are	green	(or	yellow)	but	not	both.
2. Traffic	lights	always	cycle	in	the	same	order,	from	red	to	green	to	yellow	to	red…	etc.
3. The	system	behaviour	is	lively,	i.e.,	no	traffic	light	gets	stuck	at	a	particular	colour.

##Part	2:	TCS	with	pedestrian	crossing
We	now	add	pedestrian	crossings	in	each	direction.	Pedestrians	can	push	a	button,	indicating	
that	they	are	willing	to	cross.	Pedestrian	lights	remain	red	unless	a	pedestrian	has	indicated	a	
willingness	to	cross.	Pedestrians	have	a	limited	amount	of time	for	crossing	(green	phase).
Create	a	new	specification	for	the	TCS	with	pedestrian	crossings.

Prove	that	the	new	specification	is	an	implementation	of	the	specification	of	Part	1,	under	a	refinement	mapping.
Prove	that	your	specification	meets	the	following	properties:
1. A	button	press	by	a	pedestrian	will	eventually	lead	to	a	green	pedestrian	light	in	the	
desired	direction.

2. A	pedestrian	light	can	only	become	green	when	all	vehicle	lights	are	red.

3. If	a	pedestrian	light	is	green	in	a	particular	direction	(NS	or	EW),	then	traffic	lights	in	the	
opposite	direction	must	be	red.

4. Pedestrian	lights	cycle	orderly	(red	→	green	→	yello	→	red,	etc.)

5. The	green-yellow	interval	for	pedestrians	is	shorter	than	the	green-yellow	interval	for	
vehicles	in	the	same	direction.

##Part	3:	TCS	with	Traffic-awareness

We	now	add	vehicle	sensors	in	the	road	for	traffic-awareness	in	our	TCS.	The	idea	of	a	travelaware
TCS	is	to	maximize	green	cycles	based	on	vehicle	traffic	load.	Each	lane	oncoming	to	the	
intersection	now	has	a	vehicle	occupation	sensor.	This	allows	the	TCS	to	consider	oncoming	
traffic	when	controlling	the	traffic	light.	You	may	assume	that	the	vehicle	sensor	is	perfect	
(even	detects	bicycles),	so	that	light-switching	of	the	new	TCS	system	can	be	controlled	
completely	by	sensors	rather	than	time-based	switch.

Create	a	new	specification	for	the	TCS	with	traffic-awareness.	Prove	that	the	new	specification	
is	an	implementation	of	the	specification	of	Part	2,	under	a	refinement	mapping.
Prove	that	your	specification	meets	the	following	properties:

1. If	a	vehicle	is	detected	in	an	oncoming	lane,	eventually	the	traffic	light	in	the	
corresponding	direction	will	switch	to	green.

##Part	4:	Implement	your	TCS	programs
Implement	all	three	versions	of	the	TCS	system	in	a	language	of	your	choice.	The	programs	
should	be	able	to	simulate	and	visualize	the	intersection
Annotate	your	program	code	for	traceability	to	the	specification,	i.e.,	your	annotations	should	
show	how	your	source	code relates	to	your	specification.	(This	is	called	taceability.	It	is	required	
in	many	standards	on	developing	safety-critical	systems.)

Also	add	automated	unit	tests	to	test	your	program	implementation.
