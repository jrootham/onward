import PropTypes from 'prop-types';
import React from 'react';
import FontIcon from 'material-ui/FontIcon';

const LockablePill = (props) => {
  return(
    <div className='pill lockable' onClick={props.handleClick} >
      { props.children }
      <FontIcon className="material-icons">lock_outline</FontIcon>
    </div>
  )
}

export default LockablePill;
