import PropTypes from 'prop-types';
import React from 'react';
import Paper from 'material-ui/Paper';

const OccupationCard = (props) => {
  if (!props.occupation) {
    return <div></div>
  } else {
    console.log(props.occupation)
    return(
      <div className='occupation'>
        <Paper className='card'>
          <div className='header'>
            <div className='pill'>{ props.occupation.job_title }</div>
          </div>
          <div className='details'>
            <div className='pill'>{ `Risk of automation: ${props.occupation.risk_of_automation}` }</div>
            <div className='pill'>{ `Salary: ${(props.occupation.salary).toLocaleString("en-US", {style: "currency", currency: "CAD", minimumFractionDigits: 2})}` }</div>
          </div>
        </Paper>
      </div>
    )
  }
}

export default OccupationCard;
