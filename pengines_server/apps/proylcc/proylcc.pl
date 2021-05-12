:- module(proylcc,
	[  
		put/8,
		verificarFila/4,
		verificarColumna/4,
		verificarPconsecutivos/3,
		verificarPistasEnLista/2,
		crearColumna/4,
		lenght/2,
		cantFil/2
	]).

:-use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%
% XsY es el resultado de reemplazar la ocurrencia de X en la posición XIndex de Xs por Y.

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat).
%

% FilaSat 1 si la fila +Pos satisface las pistas +PistasFilas asociadas, 0 caso contrario.
% ColSat 1 si la columna de +Pos satisface las pistas +PistasColumnas asociadas, 0 en caso contrario.  


put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, X, Y):-
	% NewGrilla es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.
	
	
	replace(Row, RowN, NewRow, Grilla, NewGrilla),
	verificarFila(NewRow,PistasFilas,NewGrilla,X),
	verificarColumna(ColN,PistasColumnas,NewGrilla,Y),
	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Conenido.	 
	
	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Contenido 
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)).

verificarFila(IndiceFila,PistasFilas,GrillaRes, 1) :- nth0(IndiceFila,PistasFilas,FiladePistas),
    nth0(IndiceFila,GrillaRes,Filadegrilla),
    verificarPistasEnLista(FiladePistas,Filadegrilla).
verificarFila(_,_,_,0).

verificarPistasEnLista([],FiladeGrilla):-not(member("#",FiladeGrilla)).
verificarPistasEnLista([X|PistasRestantes],[Y|SubfiladeGrilla]):-Y == "#", 
    verificarPconsecutivos(X,[Y|SubfiladeGrilla],Restante),
    verificarPistasEnLista(PistasRestantes,Restante).
verificarPistasEnLista(Pistas,[Y|SubfiladeGrilla]):- Y \== "#",
    verificarPistasEnLista(Pistas,SubfiladeGrilla).

verificarPconsecutivos(0,[],[]).
verificarPconsecutivos(0,[X|Filarestante],Filarestante):- X \== "#".
verificarPconsecutivos(N,[X|Filarestante],Filarestante2):- X == "#", N > 0, Naux is N-1,
    verificarPconsecutivos(Naux,Filarestante,Filarestante2).

lenght([],0).
lenght([_|L],T):-
lenght(L,T1),
T is T1+1.

cantFil(L,CF):-
lenght(L,CF).


verificarColumna(IndiceColumna,PistasColumnas,GrillaRes, 1) :- nth0(IndiceColumna,PistasColumnas,ColumnadePistas),
    cantFil(GrillaRes,Cantfilas),
    crearColumna(IndiceColumna,GrillaRes,Cantfilas,Columnadegrilla),
    verificarPistasEnLista(ColumnadePistas,Columnadegrilla).
verificarColumna(_,_,_,0).

crearColumna(_IndiceColumna,_GrillaRes,0,[]).
crearColumna(IndiceColumna,[Y|GrillaRes],Cant,[X|Restante]):- Cant \== 0, Aux is Cant-1,crearColumna(IndiceColumna,GrillaRes,Aux,Restante), nth0(IndiceColumna,Y,X).