import PropTypes from 'prop-types';
import React from 'react';
import Options from '../components/Options'

export default class OptionsContainer extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
    this.submitQuestionnaire = () => this._submitQuestionnaire()
  }

  _submitQuestionnaire() {

  }

  render() {
    return (
      <div className="page-container">
        <Options updateParams={ this.props.updateParams } { ...this.props } />
      </div>
    );
  }
}
