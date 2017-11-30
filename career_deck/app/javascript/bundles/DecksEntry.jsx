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
    this.fetchPathway = () => this._fetchPathway()
  }

  _updateParams (param, value) {
    this.setState({ [param]: value }, () => this.fetchPathway())
  }

  _fetchPathway () {
    const baseUrl = '/search?current_level=grade_11&';
    const validParams = ['noc_codes', 'ouac_codes']

    const query = Object.keys(this.state)
      .map(k => encodeURIComponent(k) + '=' + encodeURIComponent(this.state[k]))
      .join('&');

    fetch(`${baseUrl}${query}`)
      .then( res  => res.json())
      .then( pathway =>  {
        this.setState({ ...pathway });
      })
      .catch( err => console.log(err) )
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
