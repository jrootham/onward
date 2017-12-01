import PropTypes from 'prop-types';
import React from 'react';
import LockablePill from './LockablePill'

const PostSecondaryContent = ({ option, updateParams }) => {
  const lockPostSecondary = () => {
    updateParams('ouac_codes', option.ouac_program_code)
  }

  const lockUniversity = () => {
    updateParams('uni_codes', option.ouac_univ_code)
  }

  return(
    <div>
      <div className='header'>
        <LockablePill handleClick={lockPostSecondary} >{ option.program_title }</LockablePill>
      </div>
      <div className='details'>
        <LockablePill handleClick={lockUniversity} >{ option.university }</LockablePill>
        <div className='pill'>{ option.program_type }</div>
        <div className='pill'>{ `Specialization: ${option.specialization}` }</div>
        <div className='pill'>{ `Min GPA: ${option.min_gpa}` }</div>
      </div>
    </div>
  )
}

export default PostSecondaryContent;
