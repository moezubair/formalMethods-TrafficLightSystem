--------------------------- MODULE TrafficLight3 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "RED"; EW ="RED";redgreen_interval=5; yellow_interval=1; NSVeh=0; EWVeh=0;

    process (RedToGreen = 0) {  
           rtg1: await NS = "RED" /\ EW = "RED";
                if(NSVeh=1){
                    {NS:="GREEN"; EW:="RED"}
                } 
                else if(EWVeh=1){
                    {NS:="RED"; EW:="GREEN"} 
                } else if(NSVeh=0/\EWVeh=0){
                    either{ NS:="GREEN"; EW:="RED"}
                    or {NS:="RED"; EW:="GREEN"} 
                }
    }
    
    process (GreenToYellow = 1) { 
            gtx1: while (TRUE){
\*                await (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1);\* \/ (NSVeh=0/\EWVeh=0);
                
                gtx2: await (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1) \/ (NSVeh=0/\EWVeh=0);
                    if(NSVeh=0/\EWVeh=0){
                        skip;
                    } else 
                    if(NS="GREEN" /\ EWVeh=1){
                        NS:="YELLOW";
                        NSVeh:=0;
                    } else if(EW="GREEN" /\ NSVeh=1){
                        EW:="YELLOW";
                        EWVeh:=0;
                    };
                    }
    }
\*            gty1: await (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1);
\*            gty2: 
\*            if(NS="GREEN"){
\*                NS:="YELLOW";
\*                NSVeh:=0;
\*            } else if(EW="GREEN"){
\*                EW:="YELLOW";
\*                EWVeh:=0;
\*            };
\*    }
\*    
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
    
     process (ButPress = 3){
        bp1: either if(NS="RED") NSVeh:=1
            or if(EW="RED")EWVeh:=1
    }
               

}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, redgreen_interval, yellow_interval, NSVeh, EWVeh, pc

vars == << NS, EW, redgreen_interval, yellow_interval, NSVeh, EWVeh, pc >>

ProcSet == {0} \cup {1} \cup {2} \cup {3}

Init == (* Global variables *)
        /\ NS = "RED"
        /\ EW = "RED"
        /\ redgreen_interval = 5
        /\ yellow_interval = 1
        /\ NSVeh = 0
        /\ EWVeh = 0
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "rtg1"
                                        [] self = 1 -> "gtx1"
                                        [] self = 2 -> "ytr1"
                                        [] self = 3 -> "bp1"]

rtg1 == /\ pc[0] = "rtg1"
        /\ NS = "RED" /\ EW = "RED"
        /\ IF NSVeh=1
              THEN /\ NS' = "GREEN"
                   /\ EW' = "RED"
              ELSE /\ IF EWVeh=1
                         THEN /\ NS' = "RED"
                              /\ EW' = "GREEN"
                         ELSE /\ IF NSVeh=0/\EWVeh=0
                                    THEN /\ \/ /\ NS' = "GREEN"
                                               /\ EW' = "RED"
                                            \/ /\ NS' = "RED"
                                               /\ EW' = "GREEN"
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << NS, EW >>
        /\ pc' = [pc EXCEPT ![0] = "Done"]
        /\ UNCHANGED << redgreen_interval, yellow_interval, NSVeh, EWVeh >>

RedToGreen == rtg1

gtx1 == /\ pc[1] = "gtx1"
        /\ pc' = [pc EXCEPT ![1] = "gtx2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSVeh, 
                        EWVeh >>

gtx2 == /\ pc[1] = "gtx2"
        /\ (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1) \/ (NSVeh=0/\EWVeh=0)
        /\ IF NSVeh=0/\EWVeh=0
              THEN /\ TRUE
                   /\ UNCHANGED << NS, EW, NSVeh, EWVeh >>
              ELSE /\ IF NS="GREEN" /\ EWVeh=1
                         THEN /\ NS' = "YELLOW"
                              /\ NSVeh' = 0
                              /\ UNCHANGED << EW, EWVeh >>
                         ELSE /\ IF EW="GREEN" /\ NSVeh=1
                                    THEN /\ EW' = "YELLOW"
                                         /\ EWVeh' = 0
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << EW, EWVeh >>
                              /\ UNCHANGED << NS, NSVeh >>
        /\ pc' = [pc EXCEPT ![1] = "gtx1"]
        /\ UNCHANGED << redgreen_interval, yellow_interval >>

GreenToYellow == gtx1 \/ gtx2

ytr1 == /\ pc[2] = "ytr1"
        /\ NS = "YELLOW" \/ EW = "YELLOW"
        /\ pc' = [pc EXCEPT ![2] = "ytr2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSVeh, 
                        EWVeh >>

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
        /\ UNCHANGED << redgreen_interval, NSVeh, EWVeh >>

YellowToRed == ytr1 \/ ytr2

bp1 == /\ pc[3] = "bp1"
       /\ \/ /\ IF NS="RED"
                   THEN /\ NSVeh' = 1
                   ELSE /\ TRUE
                        /\ NSVeh' = NSVeh
             /\ EWVeh' = EWVeh
          \/ /\ IF EW="RED"
                   THEN /\ EWVeh' = 1
                   ELSE /\ TRUE
                        /\ EWVeh' = EWVeh
             /\ NSVeh' = NSVeh
       /\ pc' = [pc EXCEPT ![3] = "Done"]
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval >>

ButPress == bp1

Next == RedToGreen \/ GreenToYellow \/ YellowToRed \/ ButPress

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
\* Last modified Tue Nov 22 16:23:57 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
