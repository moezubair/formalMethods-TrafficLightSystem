--------------------------- MODULE TrafficLight3 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "RED"; EW ="RED"; yellow_interval=1; NSVeh=0; EWVeh=0;


    process (GreenToYellow = 1) { 
        
        gty1: await NS = "GREEN" \/ EW = "GREEN" \/ (NSVeh=0/\EWVeh=0);
        
        gty2: if(NS="RED"){
            either NSVeh:=1
            or NSVeh:=0;
        } else if(EW="RED"){
            either EWVeh:=1;
            or EWVeh:=0;
        };
        if(NS="GREEN" /\ EWVeh=1){
            NS:="YELLOW"; 
        } else if(EW="GREEN" /\ NSVeh=1){
            EW:="YELLOW";
        } else if(NS = "RED" /\ EW ="RED"){
            if(NSVeh=1){
                NS:="GREEN"
            } else{
                EW:="GREEN"
            }
        }
    }
    
    process (YellowToRedGreen = 2) {  
        ytr1: await NS = "YELLOW" \/ EW = "YELLOW" \/ (NSVeh=0/\EWVeh=0);
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
VARIABLES NS, EW, yellow_interval, NSVeh, EWVeh, pc

vars == << NS, EW, yellow_interval, NSVeh, EWVeh, pc >>

ProcSet == {1} \cup {2}

Init == (* Global variables *)
        /\ NS = "RED"
        /\ EW = "RED"
        /\ yellow_interval = 1
        /\ NSVeh = 0
        /\ EWVeh = 0
        /\ pc = [self \in ProcSet |-> CASE self = 1 -> "gty1"
                                        [] self = 2 -> "ytr1"]

gty1 == /\ pc[1] = "gty1"
        /\ NS = "GREEN" \/ EW = "GREEN" \/ (NSVeh=0/\EWVeh=0)
        /\ pc' = [pc EXCEPT ![1] = "gty2"]
        /\ UNCHANGED << NS, EW, yellow_interval, NSVeh, EWVeh >>

gty2 == /\ pc[1] = "gty2"
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
        /\ IF NS="GREEN" /\ EWVeh'=1
              THEN /\ NS' = "YELLOW"
                   /\ EW' = EW
              ELSE /\ IF EW="GREEN" /\ NSVeh'=1
                         THEN /\ EW' = "YELLOW"
                              /\ NS' = NS
                         ELSE /\ IF NS = "RED" /\ EW ="RED"
                                    THEN /\ IF NSVeh'=1
                                               THEN /\ NS' = "GREEN"
                                                    /\ EW' = EW
                                               ELSE /\ EW' = "GREEN"
                                                    /\ NS' = NS
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << NS, EW >>
        /\ pc' = [pc EXCEPT ![1] = "Done"]
        /\ UNCHANGED yellow_interval

GreenToYellow == gty1 \/ gty2

ytr1 == /\ pc[2] = "ytr1"
        /\ NS = "YELLOW" \/ EW = "YELLOW" \/ (NSVeh=0/\EWVeh=0)
        /\ pc' = [pc EXCEPT ![2] = "ytr2"]
        /\ UNCHANGED << NS, EW, yellow_interval, NSVeh, EWVeh >>

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
        /\ UNCHANGED << NSVeh, EWVeh >>

ytr3 == /\ pc[2] = "ytr3"
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

A == INSTANCE TrafficLight2 WITH NSPed<-NS, EWPed<-EW, yellow_interval_ped<-yellow_interval,NSBut<-NSVeh,EWBut<-EWVeh, redgreen_interval_ped<-2,redgreen_interval<-5, pc<-pc   
\*A == INSTANCE TrafficLight2 WITH NS<-NS, EW<-EW, redgreen_interval<-5, yellow_interval<-yellow_interval, pc<-pc  

=============================================================================
\* Modification History
\* Last modified Wed Nov 23 17:40:07 PST 2016 by Stella
\* Last modified Mon Nov 07 10:13:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
