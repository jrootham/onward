import PropTypes from 'prop-types';
import React from 'react';

const PostSecondaryContent = ({ option }) => {
  return(
    <div>
      <div className='header'>
        <div className='pill'>{ option.program_title }</div>
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
