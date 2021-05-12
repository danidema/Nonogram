import React from 'react';

class Clue extends React.Component {

    constructor(props){
        super(props);
        this.state= {
            satisface: 0
        };
    }
    render() {
        const clue = this.props.clue;
        
        return (
         <div className={this.state.satisface===1?"clue clueSatisfecho":"clue"} >  
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