import PropTypes from 'prop-types';
import React from 'react';
import Paper from 'material-ui/Paper';

const PostSecondaryCard = (props) => {
  if (!props.program) {
    return <div></div>
  } else {
    console.log(props.program)
    return(
      <div className='post-secondary'>
        <Paper className='card'>
          <div className='header'>
            <div className='pill'>{ props.program.program_title }</div>
          </div>
          <div className='details'>
          </div>
        </Paper>
      </div>
    )
  }
}

export default PostSecondaryCard;