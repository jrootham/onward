import PropTypes from 'prop-types';
import React from 'react';
import LockablePill from './LockablePill'

const PostSecondaryContent = ({ option, updateParams }) => {
  const lockPostSecondary = () => {
    updateParams('ouac_codes', option.ouac_program_code)
  }

  return(
    <div>
      <div className='header'>
        <LockablePill onClick={lockPostSecondary} >{ option.program_title }</LockablePill>
      </div>
      <div className='details'>
        <div className='pill'>{ option.university }</div>
        <div className='pill'>{ option.program_type }</div>
        <div className='pill'>{ `Specialization: ${option.specialization}` }</div>
        <div className='pill'>{ `Min GPA: ${option.min_gpa}` }</div>
      </div>
    </div>
  )
}

export default PostSecondaryContent;
