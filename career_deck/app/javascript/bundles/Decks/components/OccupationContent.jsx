import PropTypes from 'prop-types';
import React from 'react';
import LockablePill from './LockablePill'

const OccupationContent = ({ option, updateParams }) => {
  const lockNocCode = () => {
    updateParams('noc_codes', option.noc_code)
  }

  const lockSalary = () => {
    updateParams('salary', option.salary)
  }

  return(
    <div>
      <div className='header'>
        <LockablePill handleClick={lockNocCode} >{ option.job_title }
        </LockablePill>
      </div>
      <div className='details'>
        <div className='pill'>{ `Risk of automation: ${option.risk_of_automation}` }</div>
        {
          option.salary &&
          <LockablePill handleClick={lockSalary} >
            { `Salary: ${(option.salary).toLocaleString("en-US", {style: "currency", currency: "CAD", minimumFractionDigits: 2})}` }
          </LockablePill>
        }
      </div>
    </div>
  )
}

export default OccupationContent;
