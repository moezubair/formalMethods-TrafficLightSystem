--------------------------- MODULE TrafficLight2 ---------------------------
EXTENDS Naturals
(***************************************************************************
--fair algorithm trafficLight {
variables NS = "GREEN"; EW ="RED";redgreen_interval=5; yellow_interval=1; NSPed="RED"; EWPed="RED"; NSBut=0; EWBut=0;redgreen_interval_ped=2;

    process (GreenToYellow = 1) { 
        
        gty1: await NS = "GREEN" \/ EW = "GREEN";
        
        gty2: while (redgreen_interval # 0){
            redgreen_interval := redgreen_interval -1;
            if (redgreen_interval<=redgreen_interval_ped){
                 if(NSPed="GREEN"){
                     NSPed:="YELLOW"; 
                 } else if(EWPed="GREEN"){
                    EWPed:="YELLOW";
                 };
            }
        };
        if(NS="GREEN"){
            NS:="YELLOW"; 
        } else if(EW="GREEN"){
            EW:="YELLOW";
        };
        redgreen_interval := 5;
    }
    
    process (YellowToRedGreen = 2) {  
        ytr1: await NS = "YELLOW" \/ EW = "YELLOW";
        ytr2: while(yellow_interval # 0){
            yellow_interval := yellow_interval-1;
        };
        if(NSPed="YELLOW"){
            NSPed:="RED"
        } else if(EWPed="YELLOW"){
            EWPed:="RED"
        };
        if(NS="YELLOW"){
            NS:="RED";
            EW:="GREEN";
        } else if(EW="YELLOW"){
            EW:="RED";
            NS:="GREEN";
        };
        if(NS="GREEN"){
            either NSBut:=1
            or NSBut:=0;
        } else if(EW="GREEN"){
            either EWBut:=1;
            or EWBut:=0;
        };
        ytr3: if(NSBut=1 /\ NS = "GREEN" /\ EW = "RED" /\ NSPed="RED"){
            NSPed:="GREEN";
            NSBut:=0;
        } else if (EWBut=1 /\ NS = "RED" /\ EW = "GREEN" /\ EWPed="RED"){
            EWPed:="GREEN";
            EWBut:=0;
        };
        yellow_interval :=1;
    }
}
}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, redgreen_interval, yellow_interval, NSPed, EWPed, NSBut, 
          EWBut, redgreen_interval_ped, pc

vars == << NS, EW, redgreen_interval, yellow_interval, NSPed, EWPed, NSBut, 
           EWBut, redgreen_interval_ped, pc >>

ProcSet == {1} \cup {2}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ redgreen_interval = 5
        /\ yellow_interval = 1
        /\ NSPed = "RED"
        /\ EWPed = "RED"
        /\ NSBut = 0
        /\ EWBut = 0
        /\ redgreen_interval_ped = 2
        /\ pc = [self \in ProcSet |-> CASE self = 1 -> "gty1"
                                        [] self = 2 -> "ytr1"]

gty1 == /\ pc[1] = "gty1"
        /\ NS = "GREEN" \/ EW = "GREEN"
        /\ pc' = [pc EXCEPT ![1] = "gty2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                        EWPed, NSBut, EWBut, redgreen_interval_ped >>

gty2 == /\ pc[1] = "gty2"
        /\ IF redgreen_interval # 0
              THEN /\ redgreen_interval' = redgreen_interval -1
                   /\ IF redgreen_interval'<=redgreen_interval_ped
                         THEN /\ IF NSPed="GREEN"
                                    THEN /\ NSPed' = "YELLOW"
                                         /\ EWPed' = EWPed
                                    ELSE /\ IF EWPed="GREEN"
                                               THEN /\ EWPed' = "YELLOW"
                                               ELSE /\ TRUE
                                                    /\ EWPed' = EWPed
                                         /\ NSPed' = NSPed
                         ELSE /\ TRUE
                              /\ UNCHANGED << NSPed, EWPed >>
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
                   /\ UNCHANGED << NSPed, EWPed >>
        /\ UNCHANGED << yellow_interval, NSBut, EWBut, redgreen_interval_ped >>

GreenToYellow == gty1 \/ gty2

ytr1 == /\ pc[2] = "ytr1"
        /\ NS = "YELLOW" \/ EW = "YELLOW"
        /\ pc' = [pc EXCEPT ![2] = "ytr2"]
        /\ UNCHANGED << NS, EW, redgreen_interval, yellow_interval, NSPed, 
                        EWPed, NSBut, EWBut, redgreen_interval_ped >>

ytr2 == /\ pc[2] = "ytr2"
        /\ IF yellow_interval # 0
              THEN /\ yellow_interval' = yellow_interval-1
                   /\ pc' = [pc EXCEPT ![2] = "ytr2"]
                   /\ UNCHANGED << NS, EW, NSPed, EWPed, NSBut, EWBut >>
              ELSE /\ IF NSPed="YELLOW"
                         THEN /\ NSPed' = "RED"
                              /\ EWPed' = EWPed
                         ELSE /\ IF EWPed="YELLOW"
                                    THEN /\ EWPed' = "RED"
                                    ELSE /\ TRUE
                                         /\ EWPed' = EWPed
                              /\ NSPed' = NSPed
                   /\ IF NS="YELLOW"
                         THEN /\ NS' = "RED"
                              /\ EW' = "GREEN"
                         ELSE /\ IF EW="YELLOW"
                                    THEN /\ EW' = "RED"
                                         /\ NS' = "GREEN"
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << NS, EW >>
                   /\ IF NS'="GREEN"
                         THEN /\ \/ /\ NSBut' = 1
                                 \/ /\ NSBut' = 0
                              /\ EWBut' = EWBut
                         ELSE /\ IF EW'="GREEN"
                                    THEN /\ \/ /\ EWBut' = 1
                                            \/ /\ EWBut' = 0
                                    ELSE /\ TRUE
                                         /\ EWBut' = EWBut
                              /\ NSBut' = NSBut
                   /\ pc' = [pc EXCEPT ![2] = "ytr3"]
                   /\ UNCHANGED yellow_interval
        /\ UNCHANGED << redgreen_interval, redgreen_interval_ped >>

ytr3 == /\ pc[2] = "ytr3"
        /\ IF NSBut=1 /\ NS = "GREEN" /\ EW = "RED" /\ NSPed="RED"
              THEN /\ NSPed' = "GREEN"
                   /\ NSBut' = 0
                   /\ UNCHANGED << EWPed, EWBut >>
              ELSE /\ IF EWBut=1 /\ NS = "RED" /\ EW = "GREEN" /\ EWPed="RED"
                         THEN /\ EWPed' = "GREEN"
                              /\ EWBut' = 0
                         ELSE /\ TRUE
                              /\ UNCHANGED << EWPed, EWBut >>
                   /\ UNCHANGED << NSPed, NSBut >>
        /\ yellow_interval' = 1
        /\ pc' = [pc EXCEPT ![2] = "Done"]
        /\ UNCHANGED << NS, EW, redgreen_interval, redgreen_interval_ped >>

YellowToRedGreen == ytr1 \/ ytr2 \/ ytr3

Next == GreenToYellow \/ YellowToRedGreen
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

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
               /\ NSBut=1 ~> NSPed="GREEN"
               /\ EWBut=1 ~> EWPed="GREEN"
            
\*               /\ [] [NSBut=1 => NSBut'=1 \/ NSPed'="GREEN"]_vars
\*               /\ [] [EWBut=1 => EWBut'=1 \/ EWPed'="GREEN"]_vars
pedsafety == /\ ~(NSPed="GREEN" /\ EW="GREEN") \* Pedestrian cross and opposite traffic light should not both be green
             /\ ~(NSPed="YELLOW" /\ EW="GREEN") 
             /\ ~(EWPed="YELLOW" /\ NS="GREEN") 
             /\ ~(EWPed="GREEN" /\ NS="GREEN")
               

A == INSTANCE TrafficLight1 WITH NS<-NS, EW<-EW, redgreen_interval<-redgreen_interval, yellow_interval<-yellow_interval, pc<-pc          
=============================================================================
\* Modification History
\* Last modified Thu Nov 24 12:15:46 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
