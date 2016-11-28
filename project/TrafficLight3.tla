--------------------------- MODULE TrafficLight3 ---------------------------
EXTENDS Naturals
(***************************************************************************
--fair algorithm trafficLight {
variables NS = "GREEN"; EW ="RED"; NSVeh=0; EWVeh=0; NSPed="RED"; EWPed="RED"; NSBut=0; EWBut=0; 
 \* Same as part 2 but waits for a vehicle or pedestrian button push in the opposite direction first
 fair process (NSTraffic = 0){
        NSt1: while(TRUE){
             await (EWVeh=1 \/ EWBut=1) /\ NS="GREEN" /\ EW="RED" /\ NSBut=0;
                NS:="GREEN";
                NSt2: skip;
                await NSPed="RED" \/ NSPed="YELLOW";
                NS:="YELLOW";
                NSt3: skip;
                await NSPed="RED";
                NS:="RED";
                NSVeh:=0;
                EW:="GREEN";
        }
    }
    
    fair process (EWTraffic = 1){
        EWt1: while(TRUE){
              await (NSVeh=1 \/ NSBut=1) /\ EW="GREEN" /\ NS="RED" /\ EWBut=0;
                EW:="GREEN";
                EWt2: skip;
                await EWPed="RED" \/ EWPed="YELLOW";
                EW:="YELLOW";
                EWt3: skip;
                await EWPed="RED";
                EW:="RED";
                EWVeh:=0;
                NS:="GREEN";
        }
    }   
    
    fair process (NSPedTraffic = 2){
        NSPedt1: while(TRUE){
            await EW="RED" /\ NS="GREEN" /\ NSBut=1; \*
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
    \*Randomly says if there is a vehicle waiting or not
    fair process (NSVehicle = 6){
        NSv1: while(TRUE){
            await NSVeh=0;
                either NSVeh:=1
                or NSVeh:=0  
        }
    }
    
    fair process (EWVehicle = 7){
        EWv1: while(TRUE){
            await EWVeh=0;
                either EWVeh:=1
                or EWVeh:=0
        }
    }


}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut, pc

vars == << NS, EW, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut, pc >>

ProcSet == {0} \cup {1} \cup {2} \cup {3} \cup {4} \cup {5} \cup {6} \cup {7}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ NSVeh = 0
        /\ EWVeh = 0
        /\ NSPed = "RED"
        /\ EWPed = "RED"
        /\ NSBut = 0
        /\ EWBut = 0
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "NSt1"
                                        [] self = 1 -> "EWt1"
                                        [] self = 2 -> "NSPedt1"
                                        [] self = 3 -> "EWPedt1"
                                        [] self = 4 -> "NSb1"
                                        [] self = 5 -> "EWb1"
                                        [] self = 6 -> "NSv1"
                                        [] self = 7 -> "EWv1"]

NSt1 == /\ pc[0] = "NSt1"
        /\ (EWVeh=1 \/ EWBut=1) /\ NS="GREEN" /\ EW="RED" /\ NSBut=0
        /\ NS' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "NSt2"]
        /\ UNCHANGED << EW, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut >>

NSt2 == /\ pc[0] = "NSt2"
        /\ TRUE
        /\ NSPed="RED" \/ NSPed="YELLOW"
        /\ NS' = "YELLOW"
        /\ pc' = [pc EXCEPT ![0] = "NSt3"]
        /\ UNCHANGED << EW, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut >>

NSt3 == /\ pc[0] = "NSt3"
        /\ TRUE
        /\ NSPed="RED"
        /\ NS' = "RED"
        /\ NSVeh' = 0
        /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "NSt1"]
        /\ UNCHANGED << EWVeh, NSPed, EWPed, NSBut, EWBut >>

NSTraffic == NSt1 \/ NSt2 \/ NSt3

EWt1 == /\ pc[1] = "EWt1"
        /\ (NSVeh=1 \/ NSBut=1) /\ EW="GREEN" /\ NS="RED" /\ EWBut=0
        /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "EWt2"]
        /\ UNCHANGED << NS, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut >>

EWt2 == /\ pc[1] = "EWt2"
        /\ TRUE
        /\ EWPed="RED" \/ EWPed="YELLOW"
        /\ EW' = "YELLOW"
        /\ pc' = [pc EXCEPT ![1] = "EWt3"]
        /\ UNCHANGED << NS, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut >>

EWt3 == /\ pc[1] = "EWt3"
        /\ TRUE
        /\ EWPed="RED"
        /\ EW' = "RED"
        /\ EWVeh' = 0
        /\ NS' = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "EWt1"]
        /\ UNCHANGED << NSVeh, NSPed, EWPed, NSBut, EWBut >>

EWTraffic == EWt1 \/ EWt2 \/ EWt3

NSPedt1 == /\ pc[2] = "NSPedt1"
           /\ EW="RED" /\ NS="GREEN" /\ NSBut=1
           /\ NSPed' = "GREEN"
           /\ pc' = [pc EXCEPT ![2] = "NSPedt2"]
           /\ UNCHANGED << NS, EW, NSVeh, EWVeh, EWPed, NSBut, EWBut >>

NSPedt2 == /\ pc[2] = "NSPedt2"
           /\ TRUE
           /\ NSPed' = "YELLOW"
           /\ NSBut' = 0
           /\ pc' = [pc EXCEPT ![2] = "NSPedt3"]
           /\ UNCHANGED << NS, EW, NSVeh, EWVeh, EWPed, EWBut >>

NSPedt3 == /\ pc[2] = "NSPedt3"
           /\ TRUE
           /\ NS="YELLOW" \/ NS="RED"
           /\ NSPed' = "RED"
           /\ pc' = [pc EXCEPT ![2] = "NSPedt1"]
           /\ UNCHANGED << NS, EW, NSVeh, EWVeh, EWPed, NSBut, EWBut >>

NSPedTraffic == NSPedt1 \/ NSPedt2 \/ NSPedt3

EWPedt1 == /\ pc[3] = "EWPedt1"
           /\ NS="RED" /\ EW="GREEN" /\ EWBut=1
           /\ EWPed' = "GREEN"
           /\ pc' = [pc EXCEPT ![3] = "EWPedt2"]
           /\ UNCHANGED << NS, EW, NSVeh, EWVeh, NSPed, NSBut, EWBut >>

EWPedt2 == /\ pc[3] = "EWPedt2"
           /\ TRUE
           /\ EWPed' = "YELLOW"
           /\ EWBut' = 0
           /\ pc' = [pc EXCEPT ![3] = "EWPedt3"]
           /\ UNCHANGED << NS, EW, NSVeh, EWVeh, NSPed, NSBut >>

EWPedt3 == /\ pc[3] = "EWPedt3"
           /\ TRUE
           /\ EW="YELLOW" \/ EW="RED"
           /\ EWPed' = "RED"
           /\ pc' = [pc EXCEPT ![3] = "EWPedt1"]
           /\ UNCHANGED << NS, EW, NSVeh, EWVeh, NSPed, NSBut, EWBut >>

EWPedTraffic == EWPedt1 \/ EWPedt2 \/ EWPedt3

NSb1 == /\ pc[4] = "NSb1"
        /\ NSBut=0 /\ NSPed="RED"
        /\ \/ /\ NSBut' = 1
           \/ /\ NSBut' = 0
        /\ pc' = [pc EXCEPT ![4] = "NSb1"]
        /\ UNCHANGED << NS, EW, NSVeh, EWVeh, NSPed, EWPed, EWBut >>

NSButton == NSb1

EWb1 == /\ pc[5] = "EWb1"
        /\ EWBut=0 /\ EWPed="RED"
        /\ \/ /\ EWBut' = 1
           \/ /\ EWBut' = 0
        /\ pc' = [pc EXCEPT ![5] = "EWb1"]
        /\ UNCHANGED << NS, EW, NSVeh, EWVeh, NSPed, EWPed, NSBut >>

EWButton == EWb1

NSv1 == /\ pc[6] = "NSv1"
        /\ NSVeh=0
        /\ \/ /\ NSVeh' = 1
           \/ /\ NSVeh' = 0
        /\ pc' = [pc EXCEPT ![6] = "NSv1"]
        /\ UNCHANGED << NS, EW, EWVeh, NSPed, EWPed, NSBut, EWBut >>

NSVehicle == NSv1

EWv1 == /\ pc[7] = "EWv1"
        /\ EWVeh=0
        /\ \/ /\ EWVeh' = 1
           \/ /\ EWVeh' = 0
        /\ pc' = [pc EXCEPT ![7] = "EWv1"]
        /\ UNCHANGED << NS, EW, NSVeh, NSPed, EWPed, NSBut, EWBut >>

EWVehicle == EWv1

Next == NSTraffic \/ EWTraffic \/ NSPedTraffic \/ EWPedTraffic \/ NSButton
           \/ EWButton \/ NSVehicle \/ EWVehicle

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)
        /\ WF_vars(NSTraffic)
        /\ WF_vars(EWTraffic)
        /\ WF_vars(NSPedTraffic)
        /\ WF_vars(EWPedTraffic)
        /\ WF_vars(NSButton)
        /\ WF_vars(EWButton)
        /\ WF_vars(NSVehicle)
        /\ WF_vars(EWVehicle)

\* END TRANSLATION

liveness == /\ [] [NS="RED" => NS'="RED" \/ NS'="GREEN"]_vars   \* NS eventually changes to Green
            /\ [] [NS="YELLOW" => NS'="YELLOW" \/ NS'="RED"]_vars \* NS eventually changes to Red
            /\ [] [NS="GREEN" => NS'="GREEN" \/ NS'="YELLOW"]_vars \* NS eventually changes to yellow
            /\ [] [EW="RED" => EW'="RED" \/ EW'="GREEN"]_vars \* EW eventually changes to Green
            /\ [] [EW="YELLOW" => EW'="YELLOW" \/ EW'="RED"]_vars \* EW eventually changes to Red
            /\ [] [EW="GREEN" => EW'="GREEN" \/ EW'="YELLOW"]_vars \* EW eventually changes to Yellow
            /\ NSVeh=1 ~> NS="GREEN"
            /\ EWVeh=1 ~> EW="GREEN"
safety == /\ ~(NS="GREEN" /\ EW="GREEN") \* Both should not be green
          /\ ~(NS="YELLOW" /\ EW="GREEN") \*EW should not be green until NS is red
          /\ ~(NS="YELLOW" /\ EW="YELLOW") \*Both should not be yellow at the same time
          /\ ~(NS="GREEN" /\ EW="YELLOW") \* NS should not turn green until ew is red   
   
 
ProcSet2 == {0} \cup {1} \cup {2} \cup {3} \cup {4} \cup {5}
bpc == [self \in ProcSet2 |-> CASE self = 0 -> pc[0]
            [] self = 1 -> pc[1]
            [] self = 2 -> pc[2]
            [] self = 3 -> pc[3]
            [] self = 4 -> pc[4]
            [] self = 5 -> pc[5]]

A == INSTANCE TrafficLight2 WITH NSPed<-NSPed, EWPed<-EWPed, NS<-NS, EW<-EW, NSBut<-NSBut, EWBut<-EWBut, pc<-bpc     

=============================================================================
\* Modification History
\* Last modified Sun Nov 27 16:05:41 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
