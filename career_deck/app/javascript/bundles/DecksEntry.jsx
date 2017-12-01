import React from 'react';
import DecksContainer from './Decks/containers/DecksContainer';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import update from 'immutability-helper';
import { BrowserRouter } from 'react-router-dom';


export default class DecksEntry extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = this.props.data;
    this.updateParams = (param, value) => this._updateParams(param, value)
    this.getParamsFromUrl = () => this._getParamsFromUrl();
    this.fetchPathway = () => this._fetchPathway();
  }

  componentDidMount() {
    this.getParamsFromUrl();
  }

  _updateParams (param, value) {
    this.setState({ [param]: value }, () => this.fetchPathway())
  }

  _getParamsFromUrl() {
    const url_string = window.location.href
    const url = new URL(url_string);
    const current_level = url.searchParams.get("current_level");
    const maesd_codes = url.searchParams.get("maesd_codes")
    this.setState({ current_level, maesd_codes })
  }

  _fetchPathway () {
    let baseUrl = '/search?';
    const validParams = ['noc_codes', 'ouac_codes', 'maesd_codes', 'current_level']
    validParams.map((k) => {
      if (!!this.state[k]) {
        const v = this.state[k]
        baseUrl = baseUrl + `${encodeURIComponent(k)}=${encodeURIComponent(v)}&`;
      }
    })

    fetch(baseUrl)
      .then( res  => res.json())
      .then( pathway =>  {
        this.setState({
          grade_9: pathway.grade_9,
          grade_10: pathway.grade_10,
          grade_11: pathway.grade_11,
          grade_12: pathway.grade_12,
          post_secondary: pathway.post_secondary,
          occupation: pathway.occupation
        });
      })
      .catch( err => console.log(err) )
  }

  render() {
    return (
      <MuiThemeProvider>
        <BrowserRouter>
          <div className='app-container'>
            <DecksContainer
              updateParams={ this.updateParams }
              getParamsFromUrl={ this.getParamsFromUrl }
              { ...this.state }
            />
          </div>
        </BrowserRouter>
      </MuiThemeProvider>
    );
  }
}
