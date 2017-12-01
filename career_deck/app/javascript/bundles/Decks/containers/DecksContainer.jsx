import PropTypes from 'prop-types';
import React from 'react';
import CardContainer from './CardContainer'

export default class DecksContainer extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    console.log('DECKS CONTAINER', this.props)
    const hs_options = [
      {
          title: 'Grade 9',
          courses: this.props.grade_9
      },
      {
          title: 'Grade 10',
          courses: this.props.grade_10
      },
      {
          title: 'Grade 11',
          courses: this.props.grade_11
      },
      {
          title: 'Grade 12',
          courses: this.props.grade_12
      }
    ]

    return (
      <div className="decks-container">
        <CardContainer options={ hs_options } content={'highSchool'} { ...this.props } />
        <CardContainer options={ this.props.post_secondary } content={'postSecondary'} { ...this.props }/>
        <CardContainer options={ this.props.occupation } content={'occupation'} { ...this.props } />
      </div>
    );
  }
}
