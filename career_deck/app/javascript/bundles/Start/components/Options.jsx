import PropTypes from 'prop-types';
import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import Paper from 'material-ui/Paper';
import SelectField from 'material-ui/SelectField';
import DropDownMenu from 'material-ui/DropDownMenu';
import MenuItem from 'material-ui/MenuItem';
import Button from 'material-ui/RaisedButton';


export default class Options extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
    this.loadCareerOptions = () => this._loadCareerOptions();
    this.updateGrade = (v) => this._updateGrade(v);
    this.updateMaesdProgram = (event, index, value) => this._updateMaesdProgram(event, index, value);
    this.loadCareerOptions()
  }

  _loadCareerOptions() {
    fetch('/maesd_programs')
      .then( res  => res.json())
      .then( maesdPrograms =>  {
        this.setState({ maesdPrograms });
      })
      .catch( err => console.log(err) )
  }

  _updateGrade (value) {
    const level = `grade_${value}`
    return () => { this.props.updateParams('current_level', level) }
  }

  _updateMaesdProgram(event, index, value) {
    this.props.updateParams('maesd_codes', value);
  }

  render() {
    const options = this.state.maesdPrograms;

    return (
      <div className="page">
        <div className="form-container">
          <div className="block">
            <p>Answer some <strong>optional</strong> questions to help us narrow down the decks</p>
          </div>
          <Paper className="block">
              <p>What grade are you in?</p>
              <Button label='9' onClick={this.updateGrade('9')} />
              <Button label='10' onClick={this.updateGrade('10')} />
              <Button label='11' onClick={this.updateGrade('11')} />
              <Button label='12' onClick={this.updateGrade('12')} />
          </Paper>
          <Paper className="block">Where is your high school?
          </Paper>
          <Paper className="block">
            <p>What career field(s) are you interested in?</p>
            <SelectField onChange={ this.updateMaesdProgram }>
              {
                options && options.map((program, index) => (
                  <MenuItem
                    key={ index }
                    value={ program.program_code }
                    primaryText={ program.description_en }
                  />
                ))
              }
            </SelectField>
          </Paper>
        </div>
        <div className="btn-container">
          <RaisedButton label='Explore' className='btn primary'/>
        </div>
      </div>
    );
  }
}
