--------------------------- MODULE TrafficLight2 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "RED"; EW ="RED";redgreen_interval=5; yellow_interval=1; NSPed="RED"; EWPed="RED"; NSBut=0; EWBut=0;redgreen_interval_ped=4;yellow_interval_ped=1

    process (RedToGreen = 0) {  
       
       rtg1: await NS = "RED" /\ EW = "RED";
        either{ NS:="GREEN"; EW:="RED"}
        or {NS:="RED"; EW:="GREEN"} ;     
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
         
    process (ButPress = 3){
        bp1: either NSBut:=1
            or EWBut:=1
            or {EWBut:=1; NSBut:=1}
    }
    
    process (Cross = 4){
        cr1: \*await NSBut=1 \/ EWBut=1; \*(NSBut=1 /\ NS="GREEN") \/ (EWBut=1 /\ EW="GREEN");
        if(NSBut=1 /\ NS = "GREEN" /\ EW = "RED" /\ NSPed="RED"){
            NSPed:="GREEN";
            cr3: while (redgreen_interval_ped # 0){
                redgreen_interval_ped := redgreen_interval_ped -1;
            };
            NSPed:="YELLOW";
            cr4: while(yellow_interval_ped # 0){
                yellow_interval_ped := yellow_interval_ped-1;
            };
            NSPed:="RED";
            redgreen_interval_ped := 5;
            yellow_interval_ped := 1;
            NSBut := 0
        
        };
        cr5: if(EWBut=1 /\ NS = "RED" /\ EW = "GREEN" /\ EWPed="RED"){
            EWPed:="GREEN";
            cr7: while (redgreen_interval_ped # 0){
                redgreen_interval_ped := redgreen_interval_ped -1;
            };
            EWPed:="YELLOW";
            cr8: while(yellow_interval_ped # 0){
                yellow_interval_ped := yellow_interval_ped-1;
            };
            EWPed:="RED";
            redgreen_interval_ped := 5;
            yellow_interval_ped := 1;
            EWBut := 0
        }      
    }
    
}
}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, redgreen_interval, yellow_interval, NSPed, EWPed, NSBut, 
          EWBut, redgreen_interval_ped, yellow_interval_ped, pc

vars == << NS, EW, redgreen_interval, yellow_interval, NSPed, EWPed, NSBut, 
           EWBut, redgreen_interval_ped, yellow_interval_ped, pc >>

ProcSet == {0} \cup {1} \cup {2} \cup {3} \cup {4}

Init == (* Global variables *)
        /\ NS = "RED"
        /\ EW = "RED"
        /\ redgreen_interval = 5
        /\ yellow_interval = 1
        /\ NSPed = "RED"
        /\ EWPed = "RED"
        /\ NSBut = 0
        /\ EWBut = 0
        /\ redgreen_interval_ped = 4
        /\ yellow_interval_ped = 1
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "rtg1"
                                        [] self = 1 -> "gty1"
                                        [] self = 2 -> "ytr1"
                                        [] self = 3 -> "bp1"
                                        [] self = 4 -> "cr1"]

rtg1 == /\ pc[0] = "rtg1"
        /\ NS = "RED" /\ EW = "RED"
        /\ \/ /\ NS' = "GREEN"
              /\ EW' = "RED"
           \/ /\ NS' = "RED"
              /\ EW' = "GREEN"
        /\ pc' = [pc EXCEPT ![0] = "Done"]
        /\ UNCHANGED << redgreen_interval, yellow_interval, NSPed, EWPed, 
                        NSBut, EWBut, redgreen_interval_ped, 
                        yellow_interval_ped >>

RedToGreen == rtg1

gty1 == /\ pc[1] = "gty1"
        /\ NS = "GREEN" \/ EW = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "gty2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                        EWPed, NSBut, EWBut, redgreen_interval_ped, 
                        yellow_interval_ped >>

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
        /\ UNCHANGED << yellow_interval, NSPed, EWPed, NSBut, EWBut, 
                        redgreen_interval_ped, yellow_interval_ped >>

GreenToYellow == gty1 \/ gty2

ytr1 == /\ pc[2] = "ytr1"
        /\ NS = "YELLOW" \/ EW = "YELLOW"
        /\ pc' = [pc EXCEPT ![2] = "ytr2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                        EWPed, NSBut, EWBut, redgreen_interval_ped, 
                        yellow_interval_ped >>

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
        /\ UNCHANGED << redgreen_interval, NSPed, EWPed, NSBut, EWBut, 
                        redgreen_interval_ped, yellow_interval_ped >>

YellowToRed == ytr1 \/ ytr2

bp1 == /\ pc[3] = "bp1"
       /\ \/ /\ NSBut' = 1
             /\ EWBut' = EWBut
          \/ /\ EWBut' = 1
             /\ NSBut' = NSBut
          \/ /\ EWBut' = 1
             /\ NSBut' = 1
       /\ pc' = [pc EXCEPT ![3] = "Done"]
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                       EWPed, redgreen_interval_ped, yellow_interval_ped >>

ButPress == bp1

cr1 == /\ pc[4] = "cr1"
       /\ IF NSBut=1 /\ NS = "GREEN" /\ EW = "RED" /\ NSPed="RED"
             THEN /\ NSPed' = "GREEN"
                  /\ pc' = [pc EXCEPT ![4] = "cr3"]
             ELSE /\ pc' = [pc EXCEPT ![4] = "cr5"]
                  /\ NSPed' = NSPed
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, EWPed, 
                       NSBut, EWBut, redgreen_interval_ped, 
                       yellow_interval_ped >>

cr3 == /\ pc[4] = "cr3"
       /\ IF redgreen_interval_ped # 0
             THEN /\ redgreen_interval_ped' = redgreen_interval_ped -1
                  /\ pc' = [pc EXCEPT ![4] = "cr3"]
                  /\ NSPed' = NSPed
             ELSE /\ NSPed' = "YELLOW"
                  /\ pc' = [pc EXCEPT ![4] = "cr4"]
                  /\ UNCHANGED redgreen_interval_ped
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, EWPed, 
                       NSBut, EWBut, yellow_interval_ped >>

cr4 == /\ pc[4] = "cr4"
       /\ IF yellow_interval_ped # 0
             THEN /\ yellow_interval_ped' = yellow_interval_ped-1
                  /\ pc' = [pc EXCEPT ![4] = "cr4"]
                  /\ UNCHANGED << NSPed, NSBut, redgreen_interval_ped >>
             ELSE /\ NSPed' = "RED"
                  /\ redgreen_interval_ped' = 5
                  /\ yellow_interval_ped' = 1
                  /\ NSBut' = 0
                  /\ pc' = [pc EXCEPT ![4] = "cr5"]
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, EWPed, 
                       EWBut >>

cr5 == /\ pc[4] = "cr5"
       /\ IF EWBut=1 /\ NS = "RED" /\ EW = "GREEN" /\ EWPed="RED"
             THEN /\ EWPed' = "GREEN"
                  /\ pc' = [pc EXCEPT ![4] = "cr7"]
             ELSE /\ pc' = [pc EXCEPT ![4] = "Done"]
                  /\ EWPed' = EWPed
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                       NSBut, EWBut, redgreen_interval_ped, 
                       yellow_interval_ped >>

cr7 == /\ pc[4] = "cr7"
       /\ IF redgreen_interval_ped # 0
             THEN /\ redgreen_interval_ped' = redgreen_interval_ped -1
                  /\ pc' = [pc EXCEPT ![4] = "cr7"]
                  /\ EWPed' = EWPed
             ELSE /\ EWPed' = "YELLOW"
                  /\ pc' = [pc EXCEPT ![4] = "cr8"]
                  /\ UNCHANGED redgreen_interval_ped
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                       NSBut, EWBut, yellow_interval_ped >>

cr8 == /\ pc[4] = "cr8"
       /\ IF yellow_interval_ped # 0
             THEN /\ yellow_interval_ped' = yellow_interval_ped-1
                  /\ pc' = [pc EXCEPT ![4] = "cr8"]
                  /\ UNCHANGED << EWPed, EWBut, redgreen_interval_ped >>
             ELSE /\ EWPed' = "RED"
                  /\ redgreen_interval_ped' = 5
                  /\ yellow_interval_ped' = 1
                  /\ EWBut' = 0
                  /\ pc' = [pc EXCEPT ![4] = "Done"]
       /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                       NSBut >>

Cross == cr1 \/ cr3 \/ cr4 \/ cr5 \/ cr7 \/ cr8

Next == RedToGreen \/ GreenToYellow \/ YellowToRed \/ ButPress \/ Cross
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
pedliveness == /\ [] [NSPed="RED" => NSPed'="RED" \/ NSPed'="GREEN"]_vars   \* NSPed eventually changes to Green
               /\ [] [NSPed="YELLOW" => NSPed'="YELLOW" \/ NSPed'="RED"]_vars \* NSPed eventually changes to Red
               /\ [] [NSPed="GREEN" => NSPed'="GREEN" \/ NSPed'="YELLOW"]_vars \* NSPed eventually changes to yellow
               /\ [] [EWPed="RED" => EWPed'="RED" \/ EWPed'="GREEN"]_vars \* EWPed eventually changes to Green
               /\ [] [EWPed="YELLOW" => EWPed'="YELLOW" \/ EWPed'="RED"]_vars \* EWPed eventually changes to Red
               /\ [] [EWPed="GREEN" => EWPed'="GREEN" \/ EWPed'="YELLOW"]_vars \* EWPed eventually changes to Yellow
               /\ [] [NSBut=1 => NSBut=1 \/ NSPed="GREEN"]_vars
               /\ [] [EWBut=1 => EWBut=1 \/ EWPed="GREEN"]_vars



ProcSet2 == {0} \cup {1} \cup {2}
bpc == [self \in ProcSet2 |-> CASE self = 0 -> pc[0]
            [] self = 1 -> pc[1]
            [] self = 2 -> pc[2]]

A == INSTANCE TrafficLight1 WITH NS<-NS, EW<-EW, redgreen_interval<-redgreen_interval, yellow_interval<-yellow_interval, pc<-bpc          
=============================================================================
\* Modification History
\* Last modified Mon Nov 21 14:25:13 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
