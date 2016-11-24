--------------------------- MODULE TrafficLight1 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "GREEN"; EW ="RED";redgreen_interval=5; yellow_interval=1;
    
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
                NS:="RED";
                EW:="GREEN";
            } else if(EW="YELLOW"){
                EW:="RED";
                NS:="GREEN";
            };
            ytr3: yellow_interval :=1;
    }
               

}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, redgreen_interval, yellow_interval, pc

vars == << NS, EW, redgreen_interval, yellow_interval, pc >>

ProcSet == {1} \cup {2}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ redgreen_interval = 5
        /\ yellow_interval = 1
        /\ pc = [self \in ProcSet |-> CASE self = 1 -> "gty1"
                                        [] self = 2 -> "ytr1"]

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
                              /\ EW' = "GREEN"
                         ELSE /\ IF EW="YELLOW"
                                    THEN /\ EW' = "RED"
                                         /\ NS' = "GREEN"
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << NS, EW >>
                   /\ pc' = [pc EXCEPT ![2] = "ytr3"]
                   /\ UNCHANGED yellow_interval
        /\ UNCHANGED redgreen_interval

ytr3 == /\ pc[2] = "ytr3"
        /\ yellow_interval' = 1
        /\ pc' = [pc EXCEPT ![2] = "Done"]
        /\ UNCHANGED << NS, EW, redgreen_interval >>

YellowToRed == ytr1 \/ ytr2 \/ ytr3

Next == GreenToYellow \/ YellowToRed
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
          

=============================================================================
\* Modification History
\* Last modified Wed Nov 23 17:14:51 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
