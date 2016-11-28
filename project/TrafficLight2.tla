--------------------------- MODULE TrafficLight2 ---------------------------
EXTENDS Naturals
(***************************************************************************
--fair algorithm trafficLight {
variables NS = "GREEN"; EW ="RED"; NSPed="RED"; EWPed="RED"; NSBut=0; EWBut=0;
    \*switches between which light is green but pedestrian crossing takes priority
    fair process (NSTraffic = 0){
        NSt1: while(TRUE){
            await NS="GREEN" /\ NSBut=0;
            NS:="GREEN";
            NSt2: skip;
            await NSPed="RED" \/ NSPed="YELLOW";
            NS:="YELLOW";
            NSt3: skip;
            await NSPed="RED";
            NS:="RED";
            EW:="GREEN";
        }
    }
    
    fair process (EWTraffic = 1){
        EWt1: while(TRUE){
            await EW="GREEN" /\ EWBut=0;
            EW:="GREEN";
            EWt2: skip;
            await EWPed="RED" \/ EWPed="YELLOW";
            EW:="YELLOW";
            EWt3: skip;
            await EWPed="RED";
            EW:="RED";
            NS:="GREEN";
        }
    }   
    \* Pedestrian crossing only when the correct properties are met
    fair process (NSPedTraffic = 2){
        NSPedt1: while(TRUE){
            await EW="RED" /\ NS="GREEN"  /\ NSBut=1; \* 
            NSPed:="GREEN";
            NSPedt2: skip;
            NSPed:="YELLOW";
            NSBut:=0;
            NSPedt3: skip;
            
            await NS="YELLOW" \/ NS="RED";
            NSPed:="RED";
            
        }
    }
    
    fair process (EWPedTraffic = 3){
        EWPedt1: while(TRUE){
            await NS="RED" /\ EW="GREEN" /\ EWBut=1; \*
            EWPed:="GREEN";
            EWPedt2: skip;
            EWPed:="YELLOW";
            EWBut:=0;
            EWPedt3: skip;
            await EW="YELLOW" \/ EW="RED";
            EWPed:="RED";
            
        }
    }   
    \* Randomly presses a button for pedestrian crossing.
    \* Must wait for the pedestrian light to be red to ensure it doesn't continually loop on one pedestrian crossing
    fair process (NSButton = 4){
        NSb1: while(TRUE){
            await NSBut=0 /\ NSPed="RED";
                either NSBut:=1
                or NSBut:=0  
        }
    }
    
    fair process (EWButton = 5){
        EWb1: while(TRUE){
            await EWBut=0 /\ EWPed="RED";
                either EWBut:=1
                or EWBut:=0
        }
    }

}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, NSPed, EWPed, NSBut, EWBut, pc

vars == << NS, EW, NSPed, EWPed, NSBut, EWBut, pc >>

ProcSet == {0} \cup {1} \cup {2} \cup {3} \cup {4} \cup {5}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ NSPed = "RED"
        /\ EWPed = "RED"
        /\ NSBut = 0
        /\ EWBut = 0
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "NSt1"
                                        [] self = 1 -> "EWt1"
                                        [] self = 2 -> "NSPedt1"
                                        [] self = 3 -> "EWPedt1"
                                        [] self = 4 -> "NSb1"
                                        [] self = 5 -> "EWb1"]

NSt1 == /\ pc[0] = "NSt1"
        /\ NS="GREEN" /\ NSBut=0
        /\ NS' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "NSt2"]
        /\ UNCHANGED << EW, NSPed, EWPed, NSBut, EWBut >>

NSt2 == /\ pc[0] = "NSt2"
        /\ TRUE
        /\ NSPed="RED" \/ NSPed="YELLOW"
        /\ NS' = "YELLOW"
        /\ pc' = [pc EXCEPT ![0] = "NSt3"]
        /\ UNCHANGED << EW, NSPed, EWPed, NSBut, EWBut >>

NSt3 == /\ pc[0] = "NSt3"
        /\ TRUE
        /\ NSPed="RED"
        /\ NS' = "RED"
        /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "NSt1"]
        /\ UNCHANGED << NSPed, EWPed, NSBut, EWBut >>

NSTraffic == NSt1 \/ NSt2 \/ NSt3

EWt1 == /\ pc[1] = "EWt1"
        /\ EW="GREEN" /\ EWBut=0
        /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "EWt2"]
        /\ UNCHANGED << NS, NSPed, EWPed, NSBut, EWBut >>

EWt2 == /\ pc[1] = "EWt2"
        /\ TRUE
        /\ EWPed="RED" \/ EWPed="YELLOW"
        /\ EW' = "YELLOW"
        /\ pc' = [pc EXCEPT ![1] = "EWt3"]
        /\ UNCHANGED << NS, NSPed, EWPed, NSBut, EWBut >>

EWt3 == /\ pc[1] = "EWt3"
        /\ TRUE
        /\ EWPed="RED"
        /\ EW' = "RED"
        /\ NS' = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "EWt1"]
        /\ UNCHANGED << NSPed, EWPed, NSBut, EWBut >>

EWTraffic == EWt1 \/ EWt2 \/ EWt3

NSPedt1 == /\ pc[2] = "NSPedt1"
           /\ EW="RED" /\ NS="GREEN"  /\ NSBut=1
           /\ NSPed' = "GREEN"
           /\ pc' = [pc EXCEPT ![2] = "NSPedt2"]
           /\ UNCHANGED << NS, EW, EWPed, NSBut, EWBut >>

NSPedt2 == /\ pc[2] = "NSPedt2"
           /\ TRUE
           /\ NSPed' = "YELLOW"
           /\ NSBut' = 0
           /\ pc' = [pc EXCEPT ![2] = "NSPedt3"]
           /\ UNCHANGED << NS, EW, EWPed, EWBut >>

NSPedt3 == /\ pc[2] = "NSPedt3"
           /\ TRUE
           /\ NS="YELLOW" \/ NS="RED"
           /\ NSPed' = "RED"
           /\ pc' = [pc EXCEPT ![2] = "NSPedt1"]
           /\ UNCHANGED << NS, EW, EWPed, NSBut, EWBut >>

NSPedTraffic == NSPedt1 \/ NSPedt2 \/ NSPedt3

EWPedt1 == /\ pc[3] = "EWPedt1"
           /\ NS="RED" /\ EW="GREEN" /\ EWBut=1
           /\ EWPed' = "GREEN"
           /\ pc' = [pc EXCEPT ![3] = "EWPedt2"]
           /\ UNCHANGED << NS, EW, NSPed, NSBut, EWBut >>

EWPedt2 == /\ pc[3] = "EWPedt2"
           /\ TRUE
           /\ EWPed' = "YELLOW"
           /\ EWBut' = 0
           /\ pc' = [pc EXCEPT ![3] = "EWPedt3"]
           /\ UNCHANGED << NS, EW, NSPed, NSBut >>

EWPedt3 == /\ pc[3] = "EWPedt3"
           /\ TRUE
           /\ EW="YELLOW" \/ EW="RED"
           /\ EWPed' = "RED"
           /\ pc' = [pc EXCEPT ![3] = "EWPedt1"]
           /\ UNCHANGED << NS, EW, NSPed, NSBut, EWBut >>

EWPedTraffic == EWPedt1 \/ EWPedt2 \/ EWPedt3

NSb1 == /\ pc[4] = "NSb1"
        /\ NSBut=0 /\ NSPed="RED"
        /\ \/ /\ NSBut' = 1
           \/ /\ NSBut' = 0
        /\ pc' = [pc EXCEPT ![4] = "NSb1"]
        /\ UNCHANGED << NS, EW, NSPed, EWPed, EWBut >>

NSButton == NSb1

EWb1 == /\ pc[5] = "EWb1"
        /\ EWBut=0 /\ EWPed="RED"
        /\ \/ /\ EWBut' = 1
           \/ /\ EWBut' = 0
        /\ pc' = [pc EXCEPT ![5] = "EWb1"]
        /\ UNCHANGED << NS, EW, NSPed, EWPed, NSBut >>

EWButton == EWb1

Next == NSTraffic \/ EWTraffic \/ NSPedTraffic \/ EWPedTraffic \/ NSButton
           \/ EWButton

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)
        /\ WF_vars(NSTraffic)
        /\ WF_vars(EWTraffic)
        /\ WF_vars(NSPedTraffic)
        /\ WF_vars(EWPedTraffic)
        /\ WF_vars(NSButton)
        /\ WF_vars(EWButton)

\* END TRANSLATION

liveness == /\ [] [NS="RED" => NS'="RED" \/ NS'="GREEN"]_vars   \* NS eventually changes to Green
            /\ [] [NS="YELLOW" => NS'="YELLOW" \/ NS'="RED"]_vars \* NS eventually changes to Red
            /\ [] [NS="GREEN" => NS'="GREEN" \/ NS'="YELLOW"]_vars \* NS eventually changes to yellow
            /\ [] [EW="RED" => EW'="RED" \/ EW'="GREEN"]_vars \* EW eventually changes to Green
            /\ [] [EW="YELLOW" => EW'="YELLOW" \/ EW'="RED"]_vars \* EW eventually changes to Red
            /\ [] [EW="GREEN" => EW'="GREEN" \/ EW'="YELLOW"]_vars \* EW eventually changes to Yellow
safety == /\ ~(NS="GREEN" /\ EW="GREEN") \* Both should not be green
          /\ ~(NS="YELLOW" /\ EW="GREEN") \*EW should not be green until NS is red
          /\ ~(NS="YELLOW" /\ EW="YELLOW") \*Both should not be yellow at the same time
          /\ ~(NS="GREEN" /\ EW="YELLOW") \* NS should not turn green until ew is red
pedliveness == /\ [] [NSPed="RED" => NSPed'="RED" \/ NSPed'="GREEN"]_vars   \* NSPed eventually changes to Green
               /\ [] [NSPed="YELLOW" => NSPed'="YELLOW" \/ NSPed'="RED"]_vars \* NSPed eventually changes to Red
               /\ [] [NSPed="GREEN" => NSPed'="GREEN" \/ NSPed'="YELLOW"]_vars \* NSPed eventually changes to yellow
               /\ [] [EWPed="RED" => EWPed'="RED" \/ EWPed'="GREEN"]_vars \* EWPed eventually changes to Green
               /\ [] [EWPed="YELLOW" => EWPed'="YELLOW" \/ EWPed'="RED"]_vars \* EWPed eventually changes to Red
               /\ [] [EWPed="GREEN" => EWPed'="GREEN" \/ EWPed'="YELLOW"]_vars \* EWPed eventually changes to Yellow
               /\ NSBut=1 ~> NSPed="GREEN"
               /\ EWBut=1 ~> EWPed="GREEN"

pedsafety == /\ ~(NSPed="GREEN" /\ EW="GREEN") \* Pedestrian cross and opposite traffic light should not both be green
             /\ ~(NSPed="YELLOW" /\ EW="GREEN") 
             /\ ~(EWPed="YELLOW" /\ NS="GREEN") 
             /\ ~(EWPed="GREEN" /\ NS="GREEN")
               

ProcSet2 == {0} \cup {1} 
bpc == [self \in ProcSet2 |-> CASE self = 0 -> pc[0]
                              [] self = 1 -> pc[1]]
            
A == INSTANCE TrafficLight1 WITH NS<-NS, EW<-EW, pc<-bpc          
=============================================================================
\* Modification History
\* Last modified Sun Nov 27 16:04:32 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
