--------------------------- MODULE TrafficLight1 ---------------------------
EXTENDS Naturals
(***************************************************************************
--algorithm trafficLight {
variables NS = "GREEN"; EW ="RED";interval=5;
{ while (TRUE){
    while (interval # 0){
    interval := interval -1;
    };
    if (NS = "GREEN" /\ EW = "RED"){
       NS := "YELLOW";
       EW := "RED";
     }else if (NS = "YELLOW" /\ EW = "RED"){
        either {NS:="RED";EW:="RED"}
        or {NS:="RED";EW:="GREEN"}
     }else if (NS = "RED" /\ EW ="GREEN"){
       NS:= "RED";
       EW:= "YELLOW";
     }else if (NS = "RED" /\ EW = "YELLOW"){
        either{NS:= "RED"; EW:="RED"}
        or {NS:="GREEN"; EW:="RED"}
     }else if (NS="RED" /\ EW="RED"){
        either{ NS:="GREEN"; EW:="RED"}
        or {NS:="RED"; EW:="GREEN"}
     };
     interval := 5;
    }
}
}

****************************************************************************)
\* BEGIN TRANSLATION
VARIABLES NS, EW, interval, pc

vars == << NS, EW, interval, pc >>

Init == (* Global variables *)
        /\ NS = "GREEN"
        /\ EW = "RED"
        /\ interval = 5
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << NS, EW, interval >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF interval # 0
               THEN /\ interval' = interval -1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << NS, EW >>
               ELSE /\ IF NS = "GREEN" /\ EW = "RED"
                          THEN /\ NS' = "YELLOW"
                               /\ EW' = "RED"
                          ELSE /\ IF NS = "YELLOW" /\ EW = "RED"
                                     THEN /\ \/ /\ NS' = "RED"
                                                /\ EW' = "RED"
                                             \/ /\ NS' = "RED"
                                                /\ EW' = "GREEN"
                                     ELSE /\ IF NS = "RED" /\ EW ="GREEN"
                                                THEN /\ NS' = "RED"
                                                     /\ EW' = "YELLOW"
                                                ELSE /\ IF NS = "RED" /\ EW = "YELLOW"
                                                           THEN /\ \/ /\ NS' = "RED"
                                                                      /\ EW' = "RED"
                                                                   \/ /\ NS' = "GREEN"
                                                                      /\ EW' = "RED"
                                                           ELSE /\ IF NS="RED" /\ EW="RED"
                                                                      THEN /\ \/ /\ NS' = "GREEN"
                                                                                 /\ EW' = "RED"
                                                                              \/ /\ NS' = "RED"
                                                                                 /\ EW' = "GREEN"
                                                                      ELSE /\ TRUE
                                                                           /\ UNCHANGED << NS, 
                                                                                           EW >>
                    /\ interval' = 5
                    /\ pc' = "Lbl_1"

Next == Lbl_1 \/ Lbl_2

Spec == Init /\ [][Next]_vars

\* END TRANSLATION

liveness == /\ [] [NS="RED" => NS'="RED" \/ NS'="GREEN"]_vars   \* NS eventually changes to Green
            /\ [] [NS="YELLOW" => NS'="YELLOW" \/ NS'="RED"]_vars \* NS eventually changes to Red
            /\ [] [NS="GREEN" => NS'="GREEN" \/ NS'="YELLOW"]_vars \* NS eventually changes to yellow
            /\ [] [EW="RED" => EW'="RED" \/ EW'="GREEN"]_vars \* EW eventually changes to Green
            /\ [] [EW="YELLOW" => EW'="YELLOW" \/ EW'="RED"]_vars \* EW eventually changes to Red
            /\ [] [EW="GREEN" => EW'="GREEN" \/ EW'="YELLOW"]_vars \* EW eventually changes to Yellow
=============================================================================
\* Modification History
\* Last modified Sun Nov 06 16:03:51 PST 2016 by Zubair
\* Last modified Sun Nov 06 00:34:00 PDT 2016 by Zubair
\* Last modified Thu Nov 03 10:16:23 PDT 2016 by Zubair
\* Created Thu Nov 03 10:15:54 PDT 2016 by Zubair
