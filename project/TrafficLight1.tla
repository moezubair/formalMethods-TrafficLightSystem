--------------------------- MODULE TrafficLight1 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "GREEN"; EW ="RED";redgreen_interval=5; yellow_interval=1;

    process (RedToGreen = 0) {  
           rtg1: await NS = "RED" /\ EW = "RED";
            either{ NS:="GREEN"; EW:="RED"}
            or {NS:="RED"; EW:="GREEN"} 
    }
    
    process (GreenToYellow = 1) { 
            gty1: await NS = "GREEN" \/ EW = "GREEN";
            gty2: while (redgreen_interval # 0){
                redgreen_interval := redgreen_interval -1;
            };
            if(NS="GREEN"){
                NS:="YELLOW"
            } else if(EW="GREEN"){
                EW:="YELLOW"
            };
            redgreen_interval := 5;
    }
    
    process (YellowToRed = 2) {  
            ytr1: await NS = "YELLOW" \/ EW = "YELLOW";
            ytr2: while(yellow_interval # 0){
                yellow_interval := yellow_interval-1;
            };
            if(NS="YELLOW"){
                NS:="RED"
            } else if(EW="YELLOW"){
                EW:="RED"
            };
            yellow_interval :=1;
    }
               

}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, redgreen_interval, yellow_interval, pc

vars == << NS, EW, redgreen_interval, yellow_interval, pc >>

ProcSet == {0} \cup {1} \cup {2}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ redgreen_interval = 5
        /\ yellow_interval = 1
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "rtg1"
                                        [] self = 1 -> "gty1"
                                        [] self = 2 -> "ytr1"]

rtg1 == /\ pc[0] = "rtg1"
        /\ NS = "RED" /\ EW = "RED"
        /\ \/ /\ NS' = "GREEN"
              /\ EW' = "RED"
           \/ /\ NS' = "RED"
              /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "Done"]
        /\ UNCHANGED << redgreen_interval, yellow_interval >>

RedToGreen == rtg1

gty1 == /\ pc[1] = "gty1"
        /\ NS = "GREEN" \/ EW = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "gty2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval >>

gty2 == /\ pc[1] = "gty2"
        /\ IF redgreen_interval # 0
              THEN /\ redgreen_interval' = redgreen_interval -1
                   /\ pc' = [pc EXCEPT ![1] = "gty2"]
                   /\ UNCHANGED << NS, EW >>
              ELSE /\ IF NS="GREEN"
                         THEN /\ NS' = "YELLOW"
                              /\ EW' = EW
                         ELSE /\ IF EW="GREEN"
                                    THEN /\ EW' = "YELLOW"
                                    ELSE /\ TRUE
                                         /\ EW' = EW
                              /\ NS' = NS
                   /\ redgreen_interval' = 5
                   /\ pc' = [pc EXCEPT ![1] = "Done"]
        /\ UNCHANGED yellow_interval

GreenToYellow == gty1 \/ gty2

ytr1 == /\ pc[2] = "ytr1"
        /\ NS = "YELLOW" \/ EW = "YELLOW"
        /\ pc' = [pc EXCEPT ![2] = "ytr2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval >>

ytr2 == /\ pc[2] = "ytr2"
        /\ IF yellow_interval # 0
              THEN /\ yellow_interval' = yellow_interval-1
                   /\ pc' = [pc EXCEPT ![2] = "ytr2"]
                   /\ UNCHANGED << NS, EW >>
              ELSE /\ IF NS="YELLOW"
                         THEN /\ NS' = "RED"
                              /\ EW' = EW
                         ELSE /\ IF EW="YELLOW"
                                    THEN /\ EW' = "RED"
                                    ELSE /\ TRUE
                                         /\ EW' = EW
                              /\ NS' = NS
                   /\ yellow_interval' = 1
                   /\ pc' = [pc EXCEPT ![2] = "Done"]
        /\ UNCHANGED redgreen_interval

YellowToRed == ytr1 \/ ytr2

Next == RedToGreen \/ GreenToYellow \/ YellowToRed
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

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
          
\* Figure out a way to randomly choose either 1 or 0
bEWBut == IF(NS="GREEN") THEN 1
          ELSE 0 
          \*EITHER 1 
\*           OR 0
           
bNSBut == IF(EW="GREEN") THEN 1
          ELSE 0 
\*EITHER 1 
\*           OR 0

bEWPed == IF(bEWBut=1) 
           THEN EW
           ELSE "RED"
bNSPed == IF(bNSBut=1) 
           THEN NS
           ELSE "RED"

A == INSTANCE TrafficLight2 WITH NSPed <- bNSPed, EWPed <- bEWPed, EWBut <- bEWBut, NSBut <- bNSBut, redgreen_interval_ped <- redgreen_interval, yellow_interval_ped <- yellow_interval
           
=============================================================================
\* Modification History
\* Last modified Sat Nov 19 18:30:57 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
