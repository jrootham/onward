import PropTypes from 'prop-types';
import React from 'react';
import LockablePill from './LockablePill'

const HighSchoolContent = ({ option, updateParams }) => {
  if (!option) {
    return <div></div>
  } else {
    const coursesToShow = option.courses.slice(0,5);
    return(
      <div>
        <div className='header'>
          <div className='pill'>{ option.title }</div>
        </div>
        <div className='details'>
          {
            coursesToShow.map((course, index) => (
               <div key={index} className='pill'>{ `${course.course_code}: ${course.course_name_en}` }</div>
            ))
          }
        </div>
      </div>
    )
  }
}

export default HighSchoolContent;
