import React from 'react';

class Clue extends React.Component {

   
    render() {
        const clue = this.props.clue;
        const satisface = this.props.satisface;
        return (
         <div className={satisface===1?"clue clueSatisfecho":"clue"} >  
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