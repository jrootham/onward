import PropTypes from 'prop-types';
import React from 'react';

const OccupationCard = (props) => {
  return(
    <div className='occupation'>
      {
        props.occupation &&
        props.occupation.job_title
      }
    </div>
  )
}

export default OccupationCard;
