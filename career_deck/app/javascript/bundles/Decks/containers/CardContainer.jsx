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
    this.setInitialCard = () => this._setInitialCard();
  }

  componentWillReceiveProps(nextProps) {
    this.setInitialCard();
  }

  componentWillMount() {
    this.setInitialCard();
  }

  _setInitialCard() {
    const url_string = window.location.href
    const url = new URL(url_string);
    const current_level = url.searchParams.get("current_level");
    const grades = ['grade_9', 'grade_10', 'grade_11', 'grade_12'];
    const showing = this.props.content === 'highSchool' ? grades.indexOf(current_level) : 0
    this.setState({ showing })
  }

  _highSchoolData() {
    this.props[this.props.current_level]
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
