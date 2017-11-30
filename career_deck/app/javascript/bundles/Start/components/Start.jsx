import PropTypes from 'prop-types';
import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';


export default class Start extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div className="page">
        <div className="btn-container">
          <RaisedButton label='Log in' className='btn secondary' />
          <RaisedButton label='Tutorial' className='btn secondary' />
          <RaisedButton label='Start Exploring' className='btn primary'/>
        </div>
      </div>
    );
  }
}
