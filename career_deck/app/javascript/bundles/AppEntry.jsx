import React from 'react';
import StartContainer from '../bundles/Start/containers/StartContainer';
import OptionsContainer from '../bundles/Start/containers/OptionsContainer';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import { BrowserRouter } from 'react-router-dom';


export default class AppEntry extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {}
    this.updateParams = (param, value) => this._updateParams(param, value)
  }

  _updateParams (param, value) {
    this.setState({ [param]: value }, console.log(this.state))
  }

  render() {
    return (
      <MuiThemeProvider>
        <BrowserRouter>
          <OptionsContainer updateParams={ this.updateParams } {...this.state} />
        </BrowserRouter>
      </MuiThemeProvider>
    );
  }
}
