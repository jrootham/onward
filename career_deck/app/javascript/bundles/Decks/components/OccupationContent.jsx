import PropTypes from 'prop-types';
import React from 'react';

const OccupationContent = ({ option }) => {
  return(
    <div>
      <div className='header'>
        <div className='pill'>{ option.job_title }</div>
      </div>
      <div className='details'>
        <div className='pill'>{ `Risk of automation: ${option.risk_of_automation}` }</div>
        {
          option.salary &&
          <div className='pill'>{ `Salary: ${(option.salary).toLocaleString("en-US", {style: "currency", currency: "CAD", minimumFractionDigits: 2})}` }</div>
        }
      </div>
    </div>
  )
}

export default OccupationContent;
