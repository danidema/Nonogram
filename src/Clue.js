import React from 'react';

class Clue extends React.Component {
    render() {
        const clue = this.props.clue;
        /*const estado = this.props.estado;*/
        return (
         /*{this.props.state==='1'?"clue clueSatisfecho":"clue"}*/   
         <div className={"clue"} >  
                
                {clue.map((num, i) =>
                    <div key={i}>
                        {num}
                    </div>
                )}
            </div>
            
        );
    }
}

export default Clue;