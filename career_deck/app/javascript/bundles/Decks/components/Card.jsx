import PropTypes from 'prop-types';
import React from 'react';
import Paper from 'material-ui/Paper';
import OccupationContent from './OccupationContent'
import PostSecondaryContent from './PostSecondaryContent'
import HighSchoolContent from './HighSchoolContent'
import RaisedButton from 'material-ui/RaisedButton';

const Card = (props) => {

  const getContent = () => {
    if (props.content === 'occupation') {
      return OccupationContent
    } else if (props.content === 'postSecondary') {
      return PostSecondaryContent
    } else if (props.content === 'highSchool') {
      return HighSchoolContent
    }
  }

  if (!props.option) {
    return(
      <Paper className='card' style={{ borderRadius: '8px' }} >
        <div>No results available</div>
      </Paper>
      )
  } else {

    const Content = getContent();

    return(
      <Paper className='card' style={{ borderRadius: '8px' }} >
        <Content option={ props.option } { ...props } />
      </Paper>
    )
  }
}

export default Card;