--------------------------- MODULE TrafficLight3 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "RED"; EW ="RED";redgreen_interval=5; yellow_interval=1; NSVeh=0; EWVeh=0;

    process (RedToGreen = 0) {  
           rtg1: await NS = "RED" /\ EW = "RED";
                if(NSVeh=1){
                    {NS:="GREEN"; EW:="RED"};
                    NSVeh:=0;
                } 
                else if(EWVeh=1){
                    {NS:="RED"; EW:="GREEN"} ;
                    EWVeh:=0;
                } else if(NSVeh=0/\EWVeh=0){
                    either{ NS:="GREEN"; EW:="RED"};
                    or {NS:="RED"; EW:="GREEN"} ;
                }
    }
    
     process (GreenToYellow = 1){
        gty1:  await (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1) \/ (NSVeh=0/\EWVeh=0);
            if(EWVeh=1 /\ NS = "GREEN"){
                NS:="YELLOW";        
            } else if(EW = "GREEN" /\ NSVeh=1){
                EW:="YELLOW";
            };
            gty2: while(yellow_interval # 0){
                yellow_interval := yellow_interval-1;
            };
            if(NS="YELLOW"){
                NS:="RED";
            } else if(EW="YELLOW"){
                EW:="RED";
            }
            
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

ProcSet == {0} \cup {1} \cup {3}

Init == (* Global variables *)
        /\ NS = "RED"
        /\ EW = "RED"
        /\ redgreen_interval = 5
        /\ yellow_interval = 1
        /\ NSVeh = 0
        /\ EWVeh = 0
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "rtg1"
                                        [] self = 1 -> "gty1"
                                        [] self = 3 -> "bp1"]

rtg1 == /\ pc[0] = "rtg1"
        /\ NS = "RED" /\ EW = "RED"
        /\ IF NSVeh=1
              THEN /\ NS' = "GREEN"
                   /\ EW' = "RED"
                   /\ NSVeh' = 0
                   /\ EWVeh' = EWVeh
              ELSE /\ IF EWVeh=1
                         THEN /\ NS' = "RED"
                              /\ EW' = "GREEN"
                              /\ EWVeh' = 0
                         ELSE /\ IF NSVeh=0/\EWVeh=0
                                    THEN /\ \/ /\ NS' = "GREEN"
                                               /\ EW' = "RED"
                                            \/ /\ NS' = "RED"
                                               /\ EW' = "GREEN"
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << NS, EW >>
                              /\ EWVeh' = EWVeh
                   /\ NSVeh' = NSVeh
        /\ pc' = [pc EXCEPT ![0] = "Done"]
        /\ UNCHANGED << redgreen_interval, yellow_interval >>

RedToGreen == rtg1

gty1 == /\ pc[1] = "gty1"
        /\ (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1) \/ (NSVeh=0/\EWVeh=0)
        /\ IF EWVeh=1 /\ NS = "GREEN"
              THEN /\ NS' = "YELLOW"
                   /\ EW' = EW
              ELSE /\ IF EW = "GREEN" /\ NSVeh=1
                         THEN /\ EW' = "YELLOW"
                         ELSE /\ TRUE
                              /\ EW' = EW
                   /\ NS' = NS
        /\ pc' = [pc EXCEPT ![1] = "gty2"]
        /\ UNCHANGED << redgreen_interval, yellow_interval, NSVeh, EWVeh >>

gty2 == /\ pc[1] = "gty2"
        /\ IF yellow_interval # 0
              THEN /\ yellow_interval' = yellow_interval-1
                   /\ pc' = [pc EXCEPT ![1] = "gty2"]
                   /\ UNCHANGED << NS, EW >>
              ELSE /\ IF NS="YELLOW"
                         THEN /\ NS' = "RED"
                              /\ EW' = EW
                         ELSE /\ IF EW="YELLOW"
                                    THEN /\ EW' = "RED"
                                    ELSE /\ TRUE
                                         /\ EW' = EW
                              /\ NS' = NS
                   /\ pc' = [pc EXCEPT ![1] = "Done"]
                   /\ UNCHANGED yellow_interval
        /\ UNCHANGED << redgreen_interval, NSVeh, EWVeh >>

GreenToYellow == gty1 \/ gty2

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

Next == RedToGreen \/ GreenToYellow \/ ButPress
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
\* Last modified Tue Nov 22 20:36:53 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
