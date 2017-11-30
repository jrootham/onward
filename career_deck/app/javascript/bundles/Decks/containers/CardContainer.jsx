import PropTypes from 'prop-types';
import React from 'react';
import Card from '../components/Card'
import FontIcon from 'material-ui/FontIcon';

export default class CardContainer extends React.Component {

  constructor(props) {
    super(props);
    this.state = { showing: 0 };
    this.nextOccupation = () => this._nextOccupation();
    this.prevOccupation = () => this._prevOccupation();
  }

  _nextOccupation() {
    let showing;
    if (this.state.showing === this.props.options.length - 1) {
      showing = 0;
    } else {
      showing = this.state.showing + 1
    }
    this.setState({ showing });
  }

  _prevOccupation() {
    let showing;
    if (this.state.showing === 0) {
      showing = this.props.options.length - 1;
    } else {
      showing = this.state.showing - 1
    }
    this.setState({ showing });
  }

  render() {
    const option = this.props.options[this.state.showing];

    return (
      <div className="deck-container">
        <FontIcon className="material-icons" onClick={ this.prevOccupation }>navigate_before</FontIcon>
        <Card option={ option } { ...this.props } />
        <FontIcon className="material-icons" onClick={ this.nextOccupation }>navigate_next</FontIcon>
      </div>
    );
  }
}
