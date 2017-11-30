import PropTypes from 'prop-types';
import React from 'react';
import OccupationCard from '../components/OccupationCard'
import FontIcon from 'material-ui/FontIcon';

export default class OccupationDeckContainer extends React.Component {

  constructor(props) {
    super(props);
    this.state = { occupations: this.props.occupations, showing: 0 };
    this.nextOccupation = () => this._nextOccupation();
    this.prevOccupation = () => this._prevOccupation();
  }

  _nextOccupation() {
    const showing = this.state.showing += 1;
    this.setState({ showing });
  }

  _prevOccupation() {
    const showing = this.state.showing -= 1;
    this.setState({ showing });
  }

  render() {
    const occupation = this.state.occupations[this.state.showing];
    return (
      <div className="occupation-deck-container">
        <FontIcon className="material-icons" onClick={ this.nextOccupation }>navigate_before</FontIcon>
        <OccupationCard occupation={ occupation } />
        <FontIcon className="material-icons" onClick={ this.prevOccupation }>navigate_next</FontIcon>
      </div>
    );
  }
}
