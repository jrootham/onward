import PropTypes from 'prop-types';
import React from 'react';

const HighSchoolContent = ({ option }) => {
  const gradeTitle = option.replace('_', ' ').replace('g', 'G')
  return(
    <div>
      <div className='header'>
        <div className='pill'>{ gradeTitle }</div>
      </div>
      <div className='details'>

      </div>
    </div>
  )
}

export default HighSchoolContent;
