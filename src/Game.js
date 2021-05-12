import React from 'react';
import PengineClient from './PengineClient';
import Board from './Board';

class Game extends React.Component {

  pengine;

  constructor(props) {
    super(props);
    this.state = {
      simbolo:"X",
      grid: null,
      rowClues: null,
      colClues: null,
      filaSat:null,
      colSat:null,
      waiting: false
    };
    this.changeSimbolo = this.changeSimbolo.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.handlePengineCreate = this.handlePengineCreate.bind(this);
    this.pengine = new PengineClient(this.handlePengineCreate);
  }

  handlePengineCreate() {
    const queryS = 'init(PistasFilas, PistasColumns, Grilla)';
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        this.setState({
          grid: response['Grilla'],
          rowClues: response['PistasFilas'],
          colClues: response['PistasColumns'],
          filaSat: [].constructor(response['PistasFilas'].length),
          colSat: [].constructor(response['PistasColumns'].length)
        });
      }
    });
  }
  changeSimbolo(){
    if(this.state.simbolo==="#"){
      this.setState({
        simbolo: "X",
      });
    }
    else {
      this.setState({
        simbolo: "#",
      });
    }
  }
  handleClick(i, j) {
    // No action on click if we are waiting.
    if (this.state.waiting) {
      return;
    }
    // Build Prolog query to make the move, which will look as follows:
    // put("#",[0,1],[], [],[["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]], GrillaRes, FilaSat, ColSat)
    const squaresS = JSON.stringify(this.state.grid).replaceAll('"_"', "_"); // Remove quotes for variables.
    const pistasFila = JSON.stringify(this.state.rowClues);
    const pistasColumnas = JSON.stringify(this.state.colClues);
    const queryS = 'put("'+this.state.simbolo+'", [' + i + ',' + j + ']' 
    + ', ' + pistasFila + ',' + pistasColumnas + ',' + squaresS + ', GrillaRes, FilaSat, ColSat)'; /* faltan las pistas filas y las pistas columnas estan vacias.. */ 
   
    this.setState({
      waiting: true
    });
    this.pengine.query(queryS, (success, response) => {
      if (success) {
        const filAux=this.state.filaSat;
        const colAux=this.state.colSat;
        filAux[i]=response['FilaSat'];
        colAux[j]=response['ColSat'];
        console.log("Fila sat: "+filAux[i]);
        console.log("col sat: "+colAux[j]);
        this.setState({
          grid: response['GrillaRes'],
          filaSat: filAux,
          colSat: colAux,
          waiting: false,
        });
      } else {
        this.setState({
          waiting: false
        });
      }
    });
  }

  render() {
    if (this.state.grid === null) {
      return null;
    }
    const statusText = 'Sigue Jugando!';
    return (
      <div className="game">
        <Board
          grid={this.state.grid}
          rowClues={this.state.rowClues}
          colClues={this.state.colClues}
          onClick={(i, j) => this.handleClick(i,j)}
        />
        <input type="checkbox" id="switch" onClick={this.changeSimbolo}/><label for="switch"></label>
        <div className="gameInfo">
          {statusText}
        </div>
        
      </div>
    );
  }
}

export default Game;
