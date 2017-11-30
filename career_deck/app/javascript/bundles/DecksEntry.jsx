import React from 'react';
import DecksContainer from './Decks/containers/DecksContainer';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import { BrowserRouter } from 'react-router-dom';


export default class DecksEntry extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
    this.updateParams = (param, value) => this._updateParams(param, value)
  }

  _updateParams (param, value) {
    this.setState({ [param]: value }, console.log(this.state))
  }

  render() {
    console.log('state', this.state)
    return (
      <MuiThemeProvider>
        <BrowserRouter>
          <div className='app-container'>
            <DecksContainer updateParams={ this.updateParams } { ...this.state } { ...this.props.data } />
          </div>
        </BrowserRouter>
      </MuiThemeProvider>
    );
  }
}
