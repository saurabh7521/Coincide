
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
create_project: 2

00:00:072

00:00:082	
485.0782	
199.941Z17-268h px� 
�
Command: %s
1870*	planAhead2
}read_checkpoint -auto_incremental -incremental {C:/Saved Documents/Coincide/Coincide.srcs/utils_1/imports/synth_1/au_top.dcp}Z12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2N
LC:/Saved Documents/Coincide/Coincide.srcs/utils_1/imports/synth_1/au_top.dcpZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
a
Command: %s
53*	vivadotcl20
.synth_design -top au_top -part xc7a35tftg256-1Z4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
z
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2	
xc7a35tZ17-347h px� 
j
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2	
xc7a35tZ17-349h px� 
D
Loading part %s157*device2
xc7a35tftg256-1Z21-403h px� 
Z
$Part: %s does not have CEAM library.966*device2
xc7a35tftg256-1Z21-9227h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
2Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
M
#Helper process launched with PID %s4824*oasys2
8624Z8-7075h px� 
�
%s*synth2{
yStarting RTL Elaboration : Time (s): cpu = 00:00:06 ; elapsed = 00:00:07 . Memory (MB): peak = 1337.098 ; gain = 448.078
h px� 
�
5undeclared symbol '%s', assumed default net type '%s'7502*oasys2

sync_out2
wire2I
EC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/duplicator .v2
178@Z8-11241h px� 
�
.'%s' is already implicitly declared on line %s5153*oasys2

sync_out2
172I
EC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/duplicator .v2
228@Z8-8895h px� 
�
"illegal elaboration system task %s7073*oasys2
error2F
BC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/pipeline.v2
168@Z8-10812h px� 
�
synthesizing module '%s'%s4497*oasys2
au_top2
 2D
@C:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/au_top.v2
18@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
reset_conditioner2
 2K
GC:/Saved Documents/blinky/blinky.srcs/sources_1/new/reset_conditioner.v2
58@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
reset_conditioner2
 2
02
12K
GC:/Saved Documents/blinky/blinky.srcs/sources_1/new/reset_conditioner.v2
58@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2

duplicator2
 2I
EC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/duplicator .v2
58@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
edge_detector2
 2K
GC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/edge_detector.v2
128@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
edge_detector2
 2
02
12K
GC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/edge_detector.v2
128@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2

pipeline2
 2F
BC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/pipeline.v2
58@Z8-6157h px� 
H
%s
*synth20
.	Parameter DEPTH bound to: 1 - type: integer 
h p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2

pipeline2
 2
02
12F
BC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/pipeline.v2
58@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2

duplicator2
 2
02
12I
EC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/duplicator .v2
58@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2

comparator2
 2H
DC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/comparator.v2
58@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2

comparator2
 2
02
12H
DC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/comparator.v2
58@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
timer2
 2C
?C:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/timer.v2
58@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
timer2
 2
02
12C
?C:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/timer.v2
58@Z8-6155h px� 
�
-case statement is not full and has no default155*oasys2D
@C:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/au_top.v2
1608@Z8-155h px� 
�
synthesizing module '%s'%s4497*oasys2	
uart_tx2
 2E
AC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/uart_tx.v2
18@Z8-6157h px� 
S
%s
*synth2;
9	Parameter CLK_FREQ bound to: 100000000 - type: integer 
h p
x
� 
J
%s
*synth22
0	Parameter BAUD bound to: 9600 - type: integer 
h p
x
� 
�
default block is never used226*oasys2E
AC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/uart_tx.v2
488@Z8-226h px� 
�
evariable '%s' is written by both blocking and non-blocking assignments, entire logic could be removed4426*oasys2
busy2E
AC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/uart_tx.v2
528@Z8-6090h px� 
�
evariable '%s' is written by both blocking and non-blocking assignments, entire logic could be removed4426*oasys2
busy2E
AC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/uart_tx.v2
578@Z8-6090h px� 
�
evariable '%s' is written by both blocking and non-blocking assignments, entire logic could be removed4426*oasys2
busy2E
AC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/uart_tx.v2
898@Z8-6090h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2	
uart_tx2
 2
02
12E
AC:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/uart_tx.v2
18@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
au_top2
 2
02
12D
@C:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/au_top.v2
18@Z8-6155h px� 
�
�Register %s in module %s has both Set and reset with same priority. This may cause simulation mismatches. Consider rewriting code 
4878*oasys2
tmr_maxval_temp_reg2
au_top2D
@C:/Saved Documents/Coincide/Coincide.srcs/sources_1/new/au_top.v2
1398@Z8-7137h px� 
�
%s*synth2{
yFinished RTL Elaboration : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1450.227 ; gain = 561.207
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1450.227 ; gain = 561.207
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1450.227 ; gain = 561.207
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0122

1450.2272
0.000Z17-268h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
>

Processing XDC Constraints
244*projectZ1-262h px� 
=
Initializing timing engine
348*projectZ1-569h px� 
�
Parsing XDC File [%s]
179*designutils2B
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc8Z20-179h px� 
�
No ports matched '%s'.
584*	planAhead2
rx2B
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc2
498@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2B
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc2
498@Z17-55h px�
�
No ports matched '%s'.
584*	planAhead2
rx2B
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc2
508@Z12-584h px�
�
"'%s' expects at least one object.
55*common2
set_property2B
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc2
508@Z17-55h px�
�
Finished Parsing XDC File [%s]
178*designutils2B
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc8Z20-178h px� 
�
�Implementation specific constraints were found while reading constraint file [%s]. These constraints will be ignored for synthesis but will be used in implementation. Impacted constraints are listed in the file [%s].
233*project2@
>C:/Saved Documents/Coincide/Coincide.srcs/constrs_1/new/au.xdc2
.Xil/au_top_propImpl.xdcZ1-236h px� 
H
&Completed Processing XDC Constraints

245*projectZ1-263h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002

00:00:002

1554.4452
0.000Z17-268h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
 Constraint Validation Runtime : 2

00:00:002
00:00:00.0052

1554.4452
0.000Z17-268h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:20 ; elapsed = 00:00:22 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Loading part: xc7a35tftg256-1
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:20 ; elapsed = 00:00:22 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
%s
*synth20
.Start Applying 'set_property' XDC Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:20 ; elapsed = 00:00:22 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
n
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2

duplicatorZ8-802h px� 
k
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2	
uart_txZ8-802h px� 
j
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2
au_topZ8-802h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                  LISTEN |                                0 |                               00
h p
x
� 
y
%s
*synth2a
_                   PULSE |                                1 |                               01
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2

sequential2

duplicatorZ8-3354h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                    IDLE |                               00 |                               00
h p
x
� 
y
%s
*synth2a
_               START_BIT |                               01 |                               01
h p
x
� 
y
%s
*synth2a
_                    DATA |                               10 |                               10
h p
x
� 
y
%s
*synth2a
_                STOP_BIT |                               11 |                               11
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2

sequential2	
uart_txZ8-3354h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                  iSTATE |                               00 |                              000
h p
x
� 
y
%s
*synth2a
_                 iSTATE1 |                               01 |                              001
h p
x
� 
y
%s
*synth2a
_                 iSTATE0 |                               10 |                              010
h p
x
� 
y
%s
*synth2a
_                 iSTATE2 |                               11 |                              011
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2

sequential2
au_topZ8-3354h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:21 ; elapsed = 00:00:23 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
(
%s
*synth2
+---Adders : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   32 Bit       Adders := 6     
h p
x
� 
F
%s
*synth2.
,	   2 Input   14 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    5 Bit       Adders := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit       Adders := 5     
h p
x
� 
F
%s
*synth2.
,	   2 Input    3 Bit       Adders := 1     
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	               32 Bit    Registers := 6     
h p
x
� 
H
%s
*synth20
.	               14 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                8 Bit    Registers := 3     
h p
x
� 
H
%s
*synth20
.	                5 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                4 Bit    Registers := 10    
h p
x
� 
H
%s
*synth20
.	                3 Bit    Registers := 1     
h p
x
� 
H
%s
*synth20
.	                1 Bit    Registers := 22    
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   4 Input   32 Bit        Muxes := 4     
h p
x
� 
F
%s
*synth2.
,	   4 Input   14 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    5 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    4 Bit        Muxes := 8     
h p
x
� 
F
%s
*synth2.
,	   4 Input    3 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input    2 Bit        Muxes := 2     
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    1 Bit        Muxes := 23    
h p
x
� 
F
%s
*synth2.
,	   4 Input    1 Bit        Muxes := 14    
h p
x
� 
F
%s
*synth2.
,	  18 Input    1 Bit        Muxes := 1     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
p
%s
*synth2X
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:25 ; elapsed = 00:00:26 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
@
%s
*synth2(
&Start Applying XDC Timing Constraints
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:31 ; elapsed = 00:00:33 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2
}Finished Timing Optimization : Time (s): cpu = 00:00:32 ; elapsed = 00:00:33 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2~
|Finished Technology Mapping : Time (s): cpu = 00:00:32 ; elapsed = 00:00:34 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2x
vFinished IO Insertion : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
| |BlackBox name |Instances |
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
2
%s*synth2
+------+-------+------+
h px� 
2
%s*synth2
|      |Cell   |Count |
h px� 
2
%s*synth2
+------+-------+------+
h px� 
2
%s*synth2
|1     |BUFG   |     1|
h px� 
2
%s*synth2
|2     |CARRY4 |    41|
h px� 
2
%s*synth2
|3     |LUT1   |    12|
h px� 
2
%s*synth2
|4     |LUT2   |   103|
h px� 
2
%s*synth2
|5     |LUT3   |   149|
h px� 
2
%s*synth2
|6     |LUT4   |    27|
h px� 
2
%s*synth2
|7     |LUT5   |    47|
h px� 
2
%s*synth2
|8     |LUT6   |    64|
h px� 
2
%s*synth2
|9     |MUXF7  |     9|
h px� 
2
%s*synth2
|10    |FDCE   |   379|
h px� 
2
%s*synth2
|11    |FDPE   |     2|
h px� 
2
%s*synth2
|12    |FDRE   |     5|
h px� 
2
%s*synth2
|13    |FDSE   |     4|
h px� 
2
%s*synth2
|14    |IBUF   |     4|
h px� 
2
%s*synth2
|15    |OBUF   |     9|
h px� 
2
%s*synth2
+------+-------+------+
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
`
%s
*synth2H
FSynthesis finished with 0 errors, 0 critical warnings and 1 warnings.
h p
x
� 
�
%s
*synth2�
Synthesis Optimization Runtime : Time (s): cpu = 00:00:28 ; elapsed = 00:00:38 . Memory (MB): peak = 1554.445 ; gain = 561.207
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:38 ; elapsed = 00:00:40 . Memory (MB): peak = 1554.445 ; gain = 665.426
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0122

1554.4452
0.000Z17-268h px� 
T
-Analyzing %s Unisim elements for replacement
17*netlist2
50Z29-17h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1554.4452
0.000Z17-268h px� 
l
!Unisim Transformation Summary:
%s111*project2'
%No Unisim elements were transformed.
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

7873955dZ4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 
~
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
472
92
22
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
synth_design: 2

00:00:442

00:00:472

1554.4452

1064.992Z17-268h px� 
c
%s6*runtcl2G
ESynthesis results are not added to the cache due to CRITICAL_WARNING
h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.0042

1554.4452
0.000Z17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2>
<C:/Saved Documents/Coincide/Coincide.runs/synth_1/au_top.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2W
Ureport_utilization -file au_top_utilization_synth.rpt -pb au_top_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Wed Jul 24 09:52:31 2024Z17-206h px� 


End Record