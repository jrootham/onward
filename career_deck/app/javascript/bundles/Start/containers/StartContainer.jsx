import PropTypes from 'prop-types';
import React from 'react';
import Start from '../components/Start';


export default class StartContainer extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div className="page-container">
        <Start { ...this.state }/>
      </div>
    );
  }
}
