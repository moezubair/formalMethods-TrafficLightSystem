--------------------------- MODULE TrafficLight3 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "GREEN"; EW ="RED"; yellow_interval=1; NSVeh=0; EWVeh=0; NSPed="RED"; EWPed="RED"; NSBut=0; EWBut=0;


    process (GreenToYellow = 1) { 
        
        gty1: await NS = "GREEN" \/ EW = "GREEN" \/ (NSVeh=0/\EWVeh=0);
        
        if(NS="RED"){
            either NSVeh:=1
            or NSVeh:=0;
        } else if(EW="RED"){
            either EWVeh:=1;
            or EWVeh:=0;
        };
        
        gty2: if(NS="GREEN" /\ EWVeh=1){
            NS:="YELLOW"; 
\*            EWVeh:=0;
        } else if(EW="GREEN" /\ NSVeh=1){
            EW:="YELLOW";
\*            NSVeh:=0;
        } else if(NS = "RED" /\ EW ="RED"){
            if(NSVeh=1){
                NS:="GREEN"
            } else{
                EW:="GREEN"
            }
        };
        if(NSPed="GREEN" /\ NS="YELLOW"){
            NSPed:="YELLOW"; 
        } else if(EWPed="GREEN" /\ EW="YELLOW"){
            EWPed:="YELLOW";
        };
    }
    
    process (YellowToRedGreen = 2) {  
        ytr1: await NS = "YELLOW" \/ EW = "YELLOW";\* \/ (NSVeh=0/\EWVeh=0 /\ pc[1]="Done");
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
    
    
\*    process (RedToGreen = 2) {  
\*           ytr1: await NS = "RED" /\ EW = "RED";
\*           ytr2: if(NSVeh=1){
\*                    {NS:="GREEN"; EW:="RED"};
\*                    NSVeh:=0;
\*                } 
\*                else if(EWVeh=1){
\*                    {NS:="RED"; EW:="GREEN"} ;
\*                    EWVeh:=0;
\*                } else if(NSVeh=0/\EWVeh=0){
\*                    either{ NS:="GREEN"; EW:="RED"};
\*                    or {NS:="RED"; EW:="GREEN"} ;
\*                };
\*           ytr3: yellow_interval:=1;
\*    }
\*    
\*     process (GreenToYellow = 1){
\*        gty1:  await (NS = "GREEN" /\ EWVeh=1) \/ (EW = "GREEN" /\ NSVeh=1) \/ (NSVeh=0/\EWVeh=0);
\*            if(EWVeh=1 /\ NS = "GREEN"){
\*                NS:="YELLOW";        
\*            } else if(EW = "GREEN" /\ NSVeh=1){
\*                EW:="YELLOW";
\*            };
\*            gty2: while(yellow_interval # 0){
\*                yellow_interval := yellow_interval-1;
\*            };
\*            if(NS="YELLOW"){
\*                NS:="RED";
\*            } else if(EW="YELLOW"){
\*                EW:="RED";
\*            }
\*            
\*    }
\*       
\*     process (ButPress = 3){
\*        bp1: either if(NS="RED") NSVeh:=1
\*            or if(EW="RED")EWVeh:=1
\*    }            

}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, yellow_interval, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut, 
          pc

vars == << NS, EW, yellow_interval, NSVeh, EWVeh, NSPed, EWPed, NSBut, EWBut, 
           pc >>

ProcSet == {1} \cup {2}

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ yellow_interval = 1
        /\ NSVeh = 0
        /\ EWVeh = 0
        /\ NSPed = "RED"
        /\ EWPed = "RED"
        /\ NSBut = 0
        /\ EWBut = 0
        /\ pc = [self \in ProcSet |-> CASE self = 1 -> "gty1"
                                        [] self = 2 -> "ytr1"]

gty1 == /\ pc[1] = "gty1"
        /\ NS = "GREEN" \/ EW = "GREEN" \/ (NSVeh=0/\EWVeh=0)
        /\ IF NS="RED"
              THEN /\ \/ /\ NSVeh' = 1
                      \/ /\ NSVeh' = 0
                   /\ EWVeh' = EWVeh
              ELSE /\ IF EW="RED"
                         THEN /\ \/ /\ EWVeh' = 1
                                 \/ /\ EWVeh' = 0
                         ELSE /\ TRUE
                              /\ EWVeh' = EWVeh
                   /\ NSVeh' = NSVeh
        /\ pc' = [pc EXCEPT ![1] = "gty2"]
        /\ UNCHANGED << NS, EW, yellow_interval, NSPed, EWPed, NSBut, EWBut >>

gty2 == /\ pc[1] = "gty2"
        /\ IF NS="GREEN" /\ EWVeh=1
              THEN /\ NS' = "YELLOW"
                   /\ EW' = EW
              ELSE /\ IF EW="GREEN" /\ NSVeh=1
                         THEN /\ EW' = "YELLOW"
                              /\ NS' = NS
                         ELSE /\ IF NS = "RED" /\ EW ="RED"
                                    THEN /\ IF NSVeh=1
                                               THEN /\ NS' = "GREEN"
                                                    /\ EW' = EW
                                               ELSE /\ EW' = "GREEN"
                                                    /\ NS' = NS
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << NS, EW >>
        /\ IF NSPed="GREEN" /\ NS'="YELLOW"
              THEN /\ NSPed' = "YELLOW"
                   /\ EWPed' = EWPed
              ELSE /\ IF EWPed="GREEN" /\ EW'="YELLOW"
                         THEN /\ EWPed' = "YELLOW"
                         ELSE /\ TRUE
                              /\ EWPed' = EWPed
                   /\ NSPed' = NSPed
        /\ pc' = [pc EXCEPT ![1] = "Done"]
        /\ UNCHANGED << yellow_interval, NSVeh, EWVeh, NSBut, EWBut >>

GreenToYellow == gty1 \/ gty2

ytr1 == /\ pc[2] = "ytr1"
        /\ NS = "YELLOW" \/ EW = "YELLOW"
        /\ pc' = [pc EXCEPT ![2] = "ytr2"]
        /\ UNCHANGED << NS, EW, yellow_interval, NSVeh, EWVeh, NSPed, EWPed, 
                        NSBut, EWBut >>

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
        /\ UNCHANGED << NSVeh, EWVeh >>

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
        /\ UNCHANGED << NS, EW, NSVeh, EWVeh >>

YellowToRedGreen == ytr1 \/ ytr2 \/ ytr3

Next == GreenToYellow \/ YellowToRedGreen
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
          

\*ProcSet2 == {0} \cup {1} \cup {2}
\*2 4 5 = 
\*ProcSet2 == {0} \cup {1} \cup {2} \cup {3} \cup {4} \cup {5}
\*bpc == [self \in ProcSet2 |-> CASE self = 0 -> pc[0]
\*            [] self = 1 -> pc[1]
\*            [] self = 2 -> pc[1]
\*            [] self = 3 -> pc[2]
\*            [] self = 4 -> pc[1]
\*            [] self = 5 -> pc[1]]

A == INSTANCE TrafficLight2 WITH NSPed<-NSPed, EWPed<-EWPed, NS<-NS, EW<-EW, yellow_interval<-yellow_interval,NSBut<-NSBut,EWBut<-EWBut, redgreen_interval_ped<-2,redgreen_interval<-5, pc<-pc   
\*A == INSTANCE TrafficLight2 WITH NS<-NS, EW<-EW, redgreen_interval<-5, yellow_interval<-yellow_interval, pc<-pc  

=============================================================================
\* Modification History
\* Last modified Thu Nov 24 12:17:17 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
