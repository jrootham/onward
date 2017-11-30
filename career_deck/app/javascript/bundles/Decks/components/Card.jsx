import PropTypes from 'prop-types';
import React from 'react';
import Paper from 'material-ui/Paper';
import OccupationContent from './OccupationContent'
import PostSecondaryContent from './PostSecondaryContent'
import HighSchoolContent from './HighSchoolContent'
import RaisedButton from 'material-ui/RaisedButton';

const Card = (props) => {
  console.log(props)

  const getContent = () => {
    if (props.content === 'occupation') {
      return OccupationContent
    } else if (props.content === 'postSecondary') {
      return PostSecondaryContent
    } else if (props.content === 'highSchool') {
      return HighSchoolContent
    }
  }

  const handleSelectCard = () => {
    let param;
    let value;

    if (props.content === 'occupation') {
      param = 'noc_codes';
      value = props.option.noc_code;
    } else if (props.content === 'postSecondary') {
      param = 'ouac_codes';
      value = props.option.ouac_program_code;
    } else if (props.content === 'highSchool') {
      param = 'hs_courses';
      value = 'ENG4U';
    }

    props.updateParams(param, value);
  }

  if (!props.option) {
    return <div></div>
  } else {

    const Content = getContent();

    return(
      <Paper className='card' style={{ borderRadius: '8px' }} >
        <Content option={ props.option } />
        <RaisedButton label='Select' onClick={handleSelectCard} />
      </Paper>
    )
  }
}

export default Card;