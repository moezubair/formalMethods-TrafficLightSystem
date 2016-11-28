--------------------------- MODULE TrafficLight1 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "GREEN"; EW ="RED";
    \*Simply switches between which light is green
    process (NSTraffic = 0){
        NSt1: while(TRUE){
            await EW="RED" \/ NS="GREEN";
            NS:="GREEN";
            NSt2: skip;
            NS:="YELLOW";
            NSt3: skip;
            NS:="RED";
            EW:="GREEN";
        }
    }
    
    process (EWTraffic = 1){
        EWt1: while(TRUE){
            await NS="RED" \/ EW="GREEN";
            EW:="GREEN";
            EWt2: skip;
            EW:="YELLOW";
            EWt3: skip;
            EW:="RED";
            NS:="GREEN";
        }
    }       

}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, pc

vars == << NS, EW, pc >>

ProcSet == {0} \cup {1}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "NSt1"
                                        [] self = 1 -> "EWt1"]

NSt1 == /\ pc[0] = "NSt1"
        /\ EW="RED" \/ NS="GREEN"
        /\ NS' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "NSt2"]
        /\ EW' = EW

NSt2 == /\ pc[0] = "NSt2"
        /\ TRUE
        /\ NS' = "YELLOW"
        /\ pc' = [pc EXCEPT ![0] = "NSt3"]
        /\ EW' = EW

NSt3 == /\ pc[0] = "NSt3"
        /\ TRUE
        /\ NS' = "RED"
        /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "NSt1"]

NSTraffic == NSt1 \/ NSt2 \/ NSt3

EWt1 == /\ pc[1] = "EWt1"
        /\ NS="RED" \/ EW="GREEN"
        /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "EWt2"]
        /\ NS' = NS

EWt2 == /\ pc[1] = "EWt2"
        /\ TRUE
        /\ EW' = "YELLOW"
        /\ pc' = [pc EXCEPT ![1] = "EWt3"]
        /\ NS' = NS

EWt3 == /\ pc[1] = "EWt3"
        /\ TRUE
        /\ EW' = "RED"
        /\ NS' = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "EWt1"]

EWTraffic == EWt1 \/ EWt2 \/ EWt3

Next == NSTraffic \/ EWTraffic

Spec == Init /\ [][Next]_vars

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
          

=============================================================================
\* Modification History
\* Last modified Sun Nov 27 16:02:46 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
